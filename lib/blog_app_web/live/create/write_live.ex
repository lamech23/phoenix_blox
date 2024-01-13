defmodule BlogAppWeb.Create.WriteLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post

  def mount(_params, _session, socket) do
    changeset = Post.change_post(%Post{})
    socket = assign(socket, :form, to_form(changeset))

    {:ok,
     socket
     |> allow_upload(:image, accept: ~w(.jpg .jpeg .webp), max_entries: 1, auto_upload: true)
     |> assign(:uploaded_files, [])}

    #  |> IO.inspect()
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("save", post_params, socket) do
    save_post(socket, socket.assigns.live_action, post_params)
  end

  @impl true
  defp save_post(socket, :new, %{"post" => post_params}) do
    image = Map.get(socket.assigns, :uploads, %{})["image"]

    post_params_with_image =
      post_params
      |> Map.put("image", List.first(consume_files(socket |> IO.inspect())))

    post_params_with_image
    |> Map.merge(%{"image" => [post_params_with_image["image"]]})
    |> IO.inspect()
    |> Post.create()
    |> IO.inspect()
    |> case do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "post created succesfully")
         |> push_navigate(to: ~p"/live/landing")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  @impl true
  defp save_post(socket, :edit, post_params) do
    case Post.update(socket.assigns.post, post_params) do
      {:ok, post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Updated successfully")
         |> push_navigate(to: "/live/landing")}

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
