defmodule BlogAppWeb.LandingPage.LandingPageLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post
  
    # def render(%{loading: true} = assigns) do
    #   ~H"""
    #   <p class="text-center mt-20 leading-6 ">loading post ...</p>
    #   """
    # end

  def mount(params, _session, socket) do
   
       posts = Post.list_posts(params["cat"])

      {:ok, assign(socket, posts: posts)}
 
  end
end
