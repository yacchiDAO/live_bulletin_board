defmodule BulletinBoard.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :thread_id, :integer
    field :name, :string
    field :body, :string
    field :number, :integer

    timestamps()
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:thread_id, :name, :body, :number])
  end
end
