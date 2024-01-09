defmodule BlogAppWeb.LandingPage.LandingPageLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post
  
    # def render(%{loading: true} = assigns) do
    #   ~H"""
    #   <p class="text-center mt-20 leading-6 ">loading post ...</p>
    #   """
    # end

  def mount(params, _session, socket) do
    if connected?(socket) do

      socket =
        socket
        |> assign(loading: false) 
        |> stream(:posts, Post.list_posts(params["cat"]))

      {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end
end
