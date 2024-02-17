defmodule BlogAppWeb.SinglePage.SinglePageLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post

  def mount(params, _session, socket) do
    post = Post.get_post!(params["id"])
    IO.inspect(post)
    related_post = Post.list_posts(params, params["cat"])

    {:ok, assign(socket, blog: post, related: related_post, search: nil )}
  end

  def handle_event("delete_post", %{"id" => id}, socket) do
    post = Post.get_post!(id)
    Post.delete(post)

    {:noreply,
     socket
     |> redirect(to: "/")
     |> put_flash(:info, "Post deleted successfully")}
  end
end
