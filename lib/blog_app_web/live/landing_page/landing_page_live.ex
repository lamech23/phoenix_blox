defmodule BlogAppWeb.LandingPage.LandingPageLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post

  def mount(params, _session, socket) do

    posts =
      Post.list_posts(params, params["cat"])
    # filter = Post.filter_search(params)

    {:ok, assign(socket, posts: posts )}
  end


end
