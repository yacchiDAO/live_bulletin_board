defmodule BulletinBoard.Posts do
  import Ecto.Query, warn: false
  alias BulletinBoard.Repo
  alias BulletinBoard.Posts.Post

  @topic inspect(__MODULE__)

  def list_posts(thread_id) do
    Post
    |> where([p], p.thread_id == ^thread_id)
    |> order_by([p], [asc: p.number])
    |> Repo.all
  end

  def get_next_post_number(thread_id) do
    Post
    |> select([p], p.number)
    |> where([p], p.thread_id == ^thread_id)
    |> order_by([p], [desc: p.number])
    |> limit([p], 1)
    |> Repo.one
    |> Kernel.||(0)
    |> Kernel.+(1)
  end

  def create_post(%{"name" => ""} = attrs), do: create_post(Map.put(attrs, "name", "名無しさん"))
  def create_post(%{"body" => ""} = attrs), do: {:error, Post.changeset(%Post{}, attrs)}

  def create_post(%{"thread_id" => thread_id} = attrs) do
    %Post{}
    |> Post.changeset(Map.put(attrs, "number", get_next_post_number(thread_id)))
    |> Repo.insert()
  end

  def subscribe(thread_id) do
    Phoenix.PubSub.subscribe(BulletinBoard.PubSub, @topic <> "#{thread_id}")
  end

  def notify_new_post(post) do
    Phoenix.PubSub.broadcast(BulletinBoard.PubSub, @topic <> "#{post.thread_id}", {:new_post, post})
  end
end
