defmodule BlogApp.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias BlogApp.Accounts.User
  alias BlogApp.Post
  alias BlogApp.Repo


  @type t :: %__MODULE__{
          title: String.t(),
          user: User.t(),
          post: Post.t(),
       
        }
  schema "comments" do
    field :title, :string
    belongs_to :user, User
    belongs_to :post, Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:title, :user_id, :post_id])
    |> validate_required([:title])
  end


  @spec create(Map.t) :: {:ok, %__MODULE__{}} | {:error, Ecto.Changeset.t}
  def create(params) do
    %__MODULE__{}
    |> changeset(params)
    |> Repo.insert()
  end

  def change_comment(%__MODULE__{} = comment, attrs \\ %{}) do
    changeset(comment, attrs)
  end
end
