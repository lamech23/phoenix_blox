defmodule BlogApp.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :desc, :text
      add :cat, :string
      add :image, {:array, :string}, default: []
      add :user_id, references(:users)

      timestamps(type: :utc_datetime)
    end
  end
end
