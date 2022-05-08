defmodule BulletinBoard.Threads do
  import Ecto.Query, warn: false
  alias BulletinBoard.Repo
  alias BulletinBoard.Threads.Thread

  def list_threads do
    Thread
    |> order_by([p], [asc: p.id])
    |> Repo.all
  end

  def get_thread(thread_id) do
    Thread
    |> Repo.get!(thread_id)
  end

  def create_thread(%{title: title}) do
    %Thread{}
    |> Thread.changeset(%{ title: title })
    |> Repo.insert()
  end
end
