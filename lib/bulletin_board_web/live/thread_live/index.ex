defmodule BulletinBoardWeb.ThreadLive.Index do
  use BulletinBoardWeb, :live_view

  alias BulletinBoard.Threads

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :threads, list_threads())}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp list_threads do
    Threads.list_threads()
  end
end
