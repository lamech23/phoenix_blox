defmodule BlogAppWeb.LandingPage.LandingPageLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post
  alias BlogApp.Repo
  import Phoenix.HTML.Link


  def mount(params, _session, socket) do
    Phoenix.PubSub.subscribe(BlogApp.PubSub, "posts")
    page =
     Post
      |> Repo.paginate(params)

    {:ok, assign(socket, posts: page.entries, page: page, search: nil ) }
  end


  @impl true
  def handle_info({:new, post}, socket) do
    posts = Post.list_posts(post, nil)
    socket =
      socket
      |> put_flash(:info, "#{post.user.email}, just posted")
    {:noreply, assign(socket, posts: posts, search: nil)}
  end


end
