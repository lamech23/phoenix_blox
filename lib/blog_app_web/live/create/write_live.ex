defmodule BlogAppWeb.Create.WriteLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Post

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("save", post_params, socket) do
    case Post.create(post_params) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "post created succesfully")
        #  |> push_patch(to: "/live/landing")
      }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset)}
    end
  end

end
