defmodule BlogApp.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  @type t :: %__MODULE__{cat: String.t(), desc: String.t(), title: String.t()}
  alias BlogApp.Repo

  schema "posts" do
    field :cat, :string
    field :desc, :string
    field :title, :string
    field :file, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :desc, :cat])
    |> validate_required([:title, :desc, :cat])
  end

  @spec create(Map.t()) :: {:ok, t} | {:error, Ecto.Changeset.t()}
  def create(params) do
    %__MODULE__{}
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
  def list_posts(cat \\ nil) do
    query = from w in __MODULE__, order_by: [asc: :inserted_at]
    # query =
    #   if cat do
    #     where(query, [w], w.cat == ^cat)
    #   else
    #     query
    #   end

    Repo.all(query)
  end

  def get_post!(id), do: Repo.get!(__MODULE__, id)


  def change_post(%__MODULE__{} = tariff, attrs \\ %{}) do
    changeset(tariff, attrs)
  end
end
