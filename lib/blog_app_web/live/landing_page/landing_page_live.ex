defmodule BlogAppWeb.LandingPage.LandingPageLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post

  def mount(_params, _session, socket) do
    posts = Post.list_posts()
    {:ok, assign(socket , blogs: posts )}
  end



end
