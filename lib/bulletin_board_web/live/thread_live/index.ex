defmodule BulletinBoardWeb.ThreadLive.Index do
  use BulletinBoardWeb, :live_view

  alias BulletinBoard.Threads

  def mount(_params, session, socket) do
    current_user = BulletinBoard.Users.get_user_by_session_token(session["user_token"])
    {:ok,
     socket
     |> assign(:threads, list_threads())
     |> assign(:current_user, current_user)}
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
