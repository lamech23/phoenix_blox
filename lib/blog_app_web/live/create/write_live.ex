defmodule BlogAppWeb.Create.WriteLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post

  def mount(_params, session, socket) do
    
    changeset = Post.change_post(%Post{})
    socket = assign(socket, :form, to_form(changeset))

    {:ok,
     socket
     |> allow_upload(:image, accept: ~w(.jpg .jpeg .webp .png), max_entries: 1, auto_upload: true)
     |> assign(:uploaded_files, [])
     |> assign(:search, nil)}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end



  def handle_event("save", post_params, socket) do
    save_post(socket, socket.assigns.live_action, post_params)
  end

  @impl true
  defp save_post(socket, :new, %{"post" => post_params}) do
    user = socket.assigns.current_user

    post_params_with_image =
      post_params
      |> Map.put("image", List.first(consume_files(socket)))
      |> Map.put("user_id", user.id)

    post_params_with_image
    |> Map.merge(%{"image" => [post_params_with_image["image"]]})
    |> Map.merge(%{"user_id" => post_params_with_image["user_id"]})
    |> Post.create()
    |> case do
      {:ok, post} ->
        socket =
          socket
          |> put_flash(:info, "post created succesfully")
          |> push_navigate(to: ~p"/")

        Phoenix.PubSub.broadcast(BlogApp.PubSub, "posts", {:new, Map.put(post, :user, user)})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  @impl true
  defp save_post(socket, :edit, %{"post" => post_params}) do
    posts = socket.assigns.post

    post_params_with_image =
      post_params
      |> Map.put("image", List.first(consume_files(socket)))

    # Merge the image field into the post_params map
    post_params_with_image =
      Map.merge(post_params, %{"image" => [post_params_with_image["image"]]})

    update_post =
      Post.update(posts, post_params_with_image)
      |> case do
        {:ok, _post} ->
          {:noreply,
           socket
           |> put_flash(:info, "Post updated successfully")
           |> push_navigate(to: ~p"/")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign_form(socket, changeset)}
      end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "All post")
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  # validate 
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Post.changeset(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  defp apply_action(socket, :new, _params) do
    changeset = Post.change_post(%Post{})

    socket
    |> assign(:page_title, "Publish")
    |> assign(:post, %Post{})
    |> assign(:changeset, changeset)
    |> assign(:desc_title, "Create new blog")
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    post = Post.get_post!(id)
    changeset = Post.change_post(post)

    socket
    |> assign(:page_title, "Update Post ")
    |> assign(:desc_title, "Upating post ")
    |> assign(:post, post)
    |> assign(:changeset, changeset)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    socket
    |> assign(:form, to_form(changeset))
  end

  defp consume_files(socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:blog_app), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)
  end
end
