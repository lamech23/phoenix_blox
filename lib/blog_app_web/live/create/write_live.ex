defmodule BlogAppWeb.Create.WriteLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post

  def mount(_params, _session, socket) do
    changeset = Post.change_post(%Post{})
    socket = 
        assign(socket, :form, to_form(changeset))
    {:ok, socket }
  end

  

  def handle_event("save",  post_params, socket) do
    IO.inspect(post_params)
    with {:ok, post} <- Post.create(post_params),
         {:ok, file} <- Arc.Storage.put(post_params["file"]) do
          
        {
          :noreply,
          socket
          |> put_flash(:info, "post created succesfully")
          |> redirect(to: "/live/landing")
        }
      else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end


  # validate 
  def handle_event("validate", %{"post" => post_params }, socket) do 
    changeset = Post.change_post(post_params)
    {:noreply, assign(socket, changeset: changeset)}



  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    {:ok, changeset} =
      socket
      |> assign(:form, to_form(changeset))
  end
end
