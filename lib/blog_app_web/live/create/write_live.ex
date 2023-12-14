defmodule BlogAppWeb.Create.WriteLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post
  import Phoenix.HTML.Form, only: [hidden_input: 2]

  def mount(_params, _session, socket) do
    changeset = Post.change_post(%Post{})

    socket = assign(socket, :form, to_form(changeset))
    {:ok,
     socket 
     #|> allow_upload(:photo, accept: ~w(.jpg .jpeg .webp), max_entries: 2, auto_upload: true)
    }
  end


  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("save", post_params, socket) do
    save_post(socket, socket.assigns.action, post_params)
  end

  defp save_post(socket, :new, post_params ) do
 
    case Post.create(post_params) do
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
    case Post.update(socket.assigns.post, post_params) do
      {:ok, post} ->

        {:noreply,
         socket
         |> put_flash(:info, "Updated successfully")
         |> redirect(to: "/live/landin")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tarrif Rules")
  end

  # validate 


  def handle_event("validate",  post_params, socket) do
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
    post = Post.get!(id)
    changeset = Post.change_post(post)

    socket
    |> assign(:page_title, "Update Post ")
    |> assign(:desc_title, "Upating post ")
    |> assign(:id, id)
    |> assign(:changeset, changeset)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    {:ok, changeset} =
      socket
      |> assign(:form, to_form(changeset))
  end



end
