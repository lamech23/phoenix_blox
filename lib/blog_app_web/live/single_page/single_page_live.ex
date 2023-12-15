defmodule BlogAppWeb.SinglePage.SinglePageLive do
  use BlogAppWeb, :live_view
  alias  BlogApp.Post

  def mount(params, _session, socket) do
    post = Post.get_post!(params["id"])
    {:ok, assign(socket, blog: post ) }
  end
  
end
