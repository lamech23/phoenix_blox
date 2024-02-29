defmodule BlogAppWeb.LandingPage.LandingPageLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post

  def mount(params, _session, socket) do
    Phoenix.PubSub.subscribe(BlogApp.PubSub, "posts")

    posts = Post.list_posts(params, params["cat"])

    {:ok, assign(socket, posts: posts, search: nil)}
  end


  @impl true
  def handle_info({:new, post}, socket) do
    posts = Post.list_posts(%{}, nil)
    socket =
      socket
      |> put_flash(:info, "#{post.user.email}, just posted")

    {:noreply, assign(socket, posts: posts, search: nil)}
  end
end
