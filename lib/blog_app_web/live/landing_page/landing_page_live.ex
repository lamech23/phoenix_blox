defmodule BlogAppWeb.LandingPage.LandingPageLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post

  def mount(params, _session, socket) do
    posts = Post.list_posts(params["cat"]) 
    {:ok, assign(socket, blogs: posts )}
  end



end
