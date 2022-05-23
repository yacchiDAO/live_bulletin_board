defmodule BulletinBoardWeb.PostLive.Index do
  use BulletinBoardWeb, :live_view

  alias BulletinBoard.Threads
  alias BulletinBoard.Posts
  alias BulletinBoard.Posts.Post

  @topic "posts"

  def mount(%{"thread_id" => thread_id}, session, socket) do
    current_user = BulletinBoard.Users.get_user_by_session_token(session["user_token"])
    if connected?(socket) do
      Posts.subscribe(thread_id)
      subscribe(thread_id)
      :timer.send_interval(5000, self(), :hide_typing)
    end
    {:ok,
     socket
     |> assign(current_user: current_user)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"thread_id" => thread_id}) do
    socket
    |> assign(:thread, Threads.get_thread(thread_id))
    |> assign(:posts, Posts.list_posts(thread_id))
    |> assign(:typing_users, %{})
    |> assign(:user_name, "")
  end

  def handle_event("submit", %{"post" => %{"name" => name} = post_params}, socket) do
    case Posts.create_post(Map.put(post_params, "thread_id", socket.assigns.thread.id)) do
      {:ok, new_post} ->
        Posts.notify_new_post(new_post)
        {:noreply, socket |> update(:user_name, fn _ -> name end)}

      {:error, _changeset} ->
        {:noreply, socket |> put_flash(:error, "送信失敗しました")}
    end
  end

  def handle_event("typing", _params, socket) do
    Phoenix.PubSub.broadcast(BulletinBoard.PubSub, @topic <> "#{socket.assigns.thread.id}", {:typing, socket.assigns.current_user.id})
    {:noreply, socket}
  end

  def handle_info({:new_post, new_post}, socket) do
    {:noreply, socket |> update(:posts, &(&1 ++ [new_post]))}
  end

  def handle_info({:typing, user_id}, socket) do
    cond do
      user_id == socket.assigns.current_user.id ->
        {:noreply, socket}
      true ->
        {:noreply, socket |> update(:typing_users, fn users -> Map.put(users, user_id, Time.add(Time.utc_now, 5)) end)}
    end
  end

  def handle_info(:hide_typing, socket) do
    {:noreply,
     socket
     |> update(:typing_users,
               fn users ->
                 Enum.reduce(users, %{}, &(filter_active_users(&1, &2)))
               end)}
  end

  def subscribe(thread_id) do
    Phoenix.PubSub.subscribe(BulletinBoard.PubSub, @topic <> "#{thread_id}")
  end

  defp filter_active_users({user_id, time_ex}, acc) do
    cond do
      Time.compare(time_ex, Time.utc_now) == :lt ->
        Map.put(acc, user_id, time_ex)
      true ->
        acc
    end
  end
end
