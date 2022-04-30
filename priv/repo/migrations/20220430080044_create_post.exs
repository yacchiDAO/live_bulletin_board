defmodule BulletinBoard.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :thread_id, :integer, null: false
      # add :user_id, :integer, null: false
      add :number, :integer, null: false
      add :name, :string
      add :body, :text, null: false

      timestamps()
    end

    create index("posts", [:thread_id])
    # create index("posts", [:user_id])
  end
end
