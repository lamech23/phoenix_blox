defmodule BlogAppWeb.Create.WriteLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post
  alias MIME

  def mount(_params, _session, socket) do
    changeset = Post.change_post(%Post{})
    socket = assign(socket, :form, to_form(changeset))
    :application.set_env(:mime, :suffixes, %{"gzip" => ["gz"]})

    {:ok,
     socket
     |> allow_upload(:file, accept: ~w(.jpg .jpeg .webp), max_entries: 1, auto_upload: true)
     |> assign(:uploaded_files, [])}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("save", post_params, socket) do
    save_post(socket, socket.assigns.live_action, post_params)
  end

  defp save_post(socket, :new, post_params) do
    post = file_url(socket, %Post{})

    case Post.create( post,  &consume_photos(socket, &1)) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "post created succesfully")
         |> redirect(to: "/live/landing")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_post(socket, :edit, post_params) do
    post = file_url(socket, socket.assigns.post)

    case Post.update(post, post_params, &consume_photos(socket, &1)) do
      {:ok, post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Updated successfully")
         |> redirect(to: "/live/landing")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end


  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "All post")
  end

  # validate 

  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Post.changeset(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket,  changeset)}
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

  
  defp file_url(socket, %Post{} = post) do
    # get all the completed entries with a liveView built in function namely "completed []"
    # this will result to the completed images and anything that is in progres
    {completed, []} = uploaded_entries(socket, :file)

    urls =
      for entry <- completed do
      ~w(socket, "/uploads/#{entry.uuid}")
      end
      %Post{post | file: urls}
  end

  def consume_photos(socket, %Post{} = post) do
    consume_uploaded_entries(socket, :file, fn meta, entry ->
      dest = Path.join("priv/static/uploads", "#enter.uuid")
      File.cp!(meta.path, dest)
    end)

    {:ok, post}
  end
end
