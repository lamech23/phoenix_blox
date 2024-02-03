
defmodule BlogApp.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :title, :string
      add :desc, :text
      add :cat, :string
      add :image, {:array, :string}, default: []


      timestamps(type: :utc_datetime)
    end
  end
end