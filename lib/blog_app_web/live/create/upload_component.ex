defmodule BlogAppWeb.Create.UploadComponent do
  use BlogAppWeb, :live_component
  import Phoenix.HTML.Form, only: [hidden_input: 2]

  def render(assigns) do
    ~H"""
    <%!-- use phx-drop-target with the upload ref to enable file drag and drop --%>
    <section phx-drop-target={@uploads.image.ref}>
      <div class="mt-2 border-2 border-gray-300 border-dashed rounded-md px-6 pt-5 pb-6 flex justify-center">
        <div class="space-y-1 text-center">
          <svg
            class="mx-auto h-12 w-12 text-gray-400"
            stroke="currentColor"
            fill="none"
            viewBox="0 0 48 48"
            aria-hidden="true"
          >
            <path
              d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
            </path>
          </svg>
          <div class="flex text-sm text-gray-600 ml-20">
            <.live_file_input upload={@uploads.image} />
          </div>
          <p class="text-xs text-gray-500">
            PNG or JPG
          </p>
        </div>
      </div>

      <%!-- render each file entry --%>
      <%= for entry <- @uploads.image.entries do %>
        <article class="upload-entry">
          <figure class="w-40 mt-4">
            <.live_img_preview entry={entry} />
            <figcaption><%= entry.client_name %></figcaption>
          </figure>
          <div class="py-5">
            <div class="flex items-center">
              <div class="w-0 flex-1">
                <dd class="flex items-baseline">
                  <div class="ml-2 flex items-baseline text-sm font-semibold text-green-600">
                    <svg
                      class="self-center flex-shrink-0 h-5 w-5 text-green-500"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                      aria-hidden="true"
                    >
                      <path
                        fill-rule="evenodd"
                        d="M5.293 9.707a1 1 0 010-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 01-1.414 1.414L11 7.414V15a1 1 0 11-2 0V7.414L6.707 9.707a1 1 0 01-1.414 0z"
                        clip-rule="evenodd"
                      />
                    </svg>
                    <%= entry.progress %>%
                  </div>
                </dd>
              </div>
            </div>
          </div>

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
