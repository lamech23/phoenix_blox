defmodule BlogAppWeb.Create.UploadComponent do
  use BlogAppWeb, :live_component
  import Phoenix.HTML.Form, only: [hidden_input: 2]

  def render(assigns) do
    ~H"""
    <%!-- lib/my_app_web/live/upload_live.html.heex --%>

    <%!-- use phx-drop-target with the upload ref to enable file drag and drop --%>
    <section phx-drop-target={@uploads.file.ref}>
      <.live_file_input upload={@uploads.file} />

      <%!-- render each file entry --%>
      <%= for entry <- @uploads.file.entries do %>
        <article class="upload-entry">
          <figure class="w-40 mt-4">
            <.live_img_preview entry={entry} />
            <figcaption><%= entry.client_name %></figcaption>
          </figure>

          <%!-- entry.progress will update automatically for in-flight entries --%>
          <progress value={entry.progress} max="100"><%= entry.progress %>%</progress>

          <%!-- a regular click event whose handler will invoke Phoenix.LiveView.cancel_upload/3 --%>
          <button
            type="button"
            phx-click="cancel-upload"
            phx-value-ref={entry.ref}
            aria-label="cancel"
            class="text-3xl ms-4 text-red-600  "
          >
            &times;
          </button>

          <%!-- Phoenix.Component.upload_errors/2 returns a list of error atoms --%>
        </article>
      <% end %>
    </section>
    """
  end
end
