defmodule BlogApp.Post do
  use Ecto.Schema
  import Ecto.Changeset
  @type t :: %__MODULE__{cat: String.t(), desc: String.t(), title: String.t()}

  schema "posts" do
    field :cat, :string
    field :desc, :string
    field :title, :string

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


  def change_tariff(%__MODULE__{} = tariff, attrs \\ %{}) do
    changeset(tariff, attrs)
  end


end
