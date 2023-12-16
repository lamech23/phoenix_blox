defmodule BlogAppWeb.SinglePage.SinglePageLive do
  use BlogAppWeb, :live_view
  alias  BlogApp.Post

  def mount(params, _session, socket) do
    post = Post.get_post!(params["id"])
    related_post = Post.list_posts(params["cat"]) 
    {:ok, 
    assign(socket, blog: post, related: related_post )}
  end
  
end
