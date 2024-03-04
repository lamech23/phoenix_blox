defmodule BlogApp.Repo do
  use Ecto.Repo,
    otp_app: :blog_app,
    adapter: Ecto.Adapters.Postgres
    use Scrivener, page_size: 10


end
