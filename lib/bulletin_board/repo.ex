defmodule BulletinBoard.Repo do
  use Ecto.Repo,
    otp_app: :bulletin_board,
    adapter: Ecto.Adapters.Postgres
end
