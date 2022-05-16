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
      :timer.send_interval(1000, self(), :hide_typing)
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
    |> assign(:typing, nil)
  end

  def handle_event("submit", %{"post" => post_params}, socket) do
    case Posts.create_post(Map.put(post_params, "thread_id", socket.assigns.thread.id)) do
      {:ok, new_post} ->
        Posts.notify_new_post(new_post)
        {:noreply,
         socket
         |> update(:posts, &(&1 ++ [new_post]))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> put_flash(:error, "送信失敗しました")}
    end
  end

  def handle_event("typing", _params, socket) do
    Phoenix.PubSub.broadcast(BulletinBoard.PubSub, @topic <> "#{socket.assigns.thread.id}", :typing)
    {:noreply, socket}
  end

  def handle_info({:new_post, new_post}, socket) do
    {:noreply, socket |> update(:posts, &(&1 ++ [new_post]))}
  end

  def handle_info(:typing, socket) do
    {:noreply, socket |> update(:typing, fn _ -> Time.add(Time.utc_now, 3) end)}
  end

  def handle_info(:hide_typing, socket) do
    {:noreply, socket |> update(:typing, fn typing -> if typing && Time.compare(typing, Time.utc_now) == :lt, do: nil, else: typing end)}
  end

  def subscribe(thread_id) do
    Phoenix.PubSub.subscribe(BulletinBoard.PubSub, @topic <> "#{thread_id}")
  end
end
