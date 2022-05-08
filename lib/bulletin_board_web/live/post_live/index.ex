defmodule BulletinBoardWeb.PostLive.Index do
  use BulletinBoardWeb, :live_view

  alias BulletinBoard.Threads
  alias BulletinBoard.Posts
  alias BulletinBoard.Posts.Post

  @topic "posts"

  def mount(%{"thread_id" => thread_id}, _session, socket) do
    if connected?(socket), do: Posts.subscribe(thread_id)
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"thread_id" => thread_id}) do
    socket
    |> assign(:thread, Threads.get_thread(thread_id))
    |> assign(:posts, Posts.list_posts(thread_id))
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

  def handle_info({:new_post, new_post}, socket) do
    {:noreply, socket |> update(:posts, &(&1 ++ [new_post]))}
  end
end
