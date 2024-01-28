defmodule BlogApp.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  @type t :: %__MODULE__{cat: String.t(), desc: String.t(), title: String.t(), image: String.t()}
  alias BlogApp.Repo
  alias BlogApp.Accounts.User

  schema "posts" do
    field :cat, :string
    field :desc, :string
    field :title, :string
    field :image, {:array, :string}, default: []
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :desc, :cat, :image])
    |> validate_required([:title, :desc, :cat, :image])
    |> validate_length(:desc, min: 10)
    |> validate_length(:title, min: 10)
  end

  @spec create(Map.t()) :: {:ok, t} | {:error, Ecto.Changeset.t()}
  def create(params) do
    %__MODULE__{}
    # |> Ecto.build_assoc(:user)
    |> changeset(params)
    |> Repo.insert()
  end

  @spec update(t, Map.t()) :: {:ok, t} | {:error, Ecto.Changeset.t()}
  def update(post, params) do
    post
    |> changeset(params)
    |> Repo.update()
  end

  # this gets all the posts else with the specific category
  def list_posts(params, cat) do
    search_term = get_in(params, ["search"])

    query =
      from p in __MODULE__,
        order_by: [desc: :inserted_at]
        # where: ilike(p.title, ^search_term) or ilike(p.cat, ^search_term)

    query =
      if cat do
        where(query, [p], p.cat == ^cat)
      else
        query
      end
    |>  Repo.all()


  end

  def filter_search(params) do
    search_term = get_in(params, ["search"])

    __MODULE__
    |> search(search_term)
    |> Repo.all()
  end

  def get_post!(id) do
    Repo.get!(__MODULE__, id)
  end

  def delete(post) do
    Repo.delete(post)
  end

  def change_post(%__MODULE__{} = tariff, attrs \\ %{}) do
    changeset(tariff, attrs)
  end

  defp search(query, term) do
    search_term = "%#{term}%"

    from post in query,
      where: ilike(post.title, ^search_term)
  end
end
