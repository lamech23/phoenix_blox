defmodule BlogAppWeb.SinglePage.SinglePageLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post
  alias BlogApp.Comments.Comment

  def mount(params, _session, socket) do
    post = Post.get_post!(params["id"])
    {:ok, relative_time} = Timex.format(post.updated_at, "{relative}", :relative)
    post = Map.put(post, :relative, relative_time)
    
    related_post = Post.list_posts(params, params["cat"])
    comments = Comment.get_comments_for_post(params["id"])
    

    changeset = Comment.change_comment(%Comment{})
    socket = assign(socket, :form, to_form(changeset))

    {:ok, assign(socket, blog: post, related: related_post, search: nil, comment: comments)}
  end

  def handle_event("delete_post", %{"id" => id}, socket) do
    post = Post.get_post!(id)
    Post.delete(post)

    {:noreply,
     socket
     |> redirect(to: "/")
     |> put_flash(:info, "Post deleted successfully")}
  end

  # @impl true
  def handle_event("save_comment", comment_params, socket) do
    current_path = socket.assigns.current_path

    user = socket.assigns.current_user
    post = socket.assigns.blog

    comment_params_with_refrences_id =
      comment_params
      |> Map.put("user_id", user.id)
      |> Map.put("post_id", post.id)

    comment_params_with_refrences_id
    |> Map.merge(%{"user_id" => comment_params_with_refrences_id["user_id"]})
    |> Map.merge(%{"post_id" => comment_params_with_refrences_id["post_id"]})
    |> Comment.create()
    |> case do
      {:ok, _comment} ->
        {:noreply,
         socket
         |> put_flash(:info, " created succesfully")
         |> push_patch(to: "live/#{post.id}/single")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    socket
    |> assign(:form, to_form(changeset))
  end
end
