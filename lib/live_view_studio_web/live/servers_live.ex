defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Servers
  # import Phoenix.HTML.Form
  import LiveViewStudioWeb.Router.Helpers

  def mount(_params, _session, socket) do
    if connected?(socket), do: Servers.subscribe()

    servers = Servers.list_servers()
    selected_server = hd!(servers)

    socket =
      assign(socket,
        changeset: nil,
        servers: servers,
        selected_server: selected_server
      )

    {:ok, socket}
  end

  def hd!(servers) do
    if length(servers) > 0, do: hd(servers), else: nil
  end

  def handle_params(%{"name" => name}, _url, socket) do
    IO.inspect("handle_params name")
    server = Servers.get_server_by_name(name)
    IO.inspect(server)
    socket = assign(socket, selected_server: server, page_title: server.name)
    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do
    socket =
      if socket.assigns.live_action == :new do
        socket =
          update(socket, :changeset, fn
            nil -> Servers.change_server(%Servers.Server{})
            changeset -> changeset
          end)

        IO.inspect(socket.assigns)
        assign(socket, selected_server: nil)
      else
        first_server = hd!(socket.assigns.servers)
        assign(socket, selected_server: first_server)
      end

    {:noreply, socket}
  end

  def handle_event("toggle_status", %{"id" => id}, socket) do
    server = Servers.get_server!(id)
    {:ok, _server} = Servers.toggle_status(server)
    {:noreply, socket}
  end

  def handle_event("validate", %{"server" => params}, socket) do
    IO.inspect("validate")

    changeset =
      Servers.change_server(%Servers.Server{}, params)
      |> Map.put(:action, :insert)

    socket = assign(socket, changeset: changeset)
    {:noreply, socket}
  end

  def handle_event("stashForm", params, socket) do
    IO.inspect("stashForm")

    nested_params =
      decode_params(params)
      |> Map.get("server")

    changeset = Servers.change_server(%Servers.Server{}, nested_params)
    socket = assign(socket, changeset: changeset)
    {:noreply, socket}
  end

  def handle_event("save", %{"server" => params}, socket) do
    IO.inspect("save")

    socket =
      case Servers.create_server(params) do
        {:ok, server} ->
          path = live_path(socket, __MODULE__, name: server.name)
          IO.inspect(path)

          socket
          |> assign(changeset: nil)
          |> push_patch(to: path)

        {:error, changeset} ->
          assign(socket, changeset: changeset)
      end

    {:noreply, socket}
  end

  def handle_info({:server_created, server}, socket) do
    socket = update(socket, :servers, fn servers -> [server | servers] end)
    {:noreply, socket}
  end

  def handle_info({:server_updated, server}, socket) do
    IO.inspect("server_updated")

    socket =
      socket
      |> update(:servers, fn servers -> update_servers(servers, server) end)
      |> update(:selected_server, fn selected ->
        if selected && selected.id == server.id, do: server, else: selected
      end)

    {:noreply, socket}
  end

  def update_servers(servers, updated) do
    index = Enum.find_index(servers, fn s -> s.id == updated.id end)
    List.replace_at(servers, index, updated)
  end

  def decode_params(params) do
    params
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      path =
        key
        |> String.split(~w([ ]), trim: true)
        |> Enum.map(&Access.key(&1, %{}))

      put_in(acc, path, value)
    end)
  end

  defp link_body(%{server: server}) do
    # defp link_body(server) do
    # IO.inspect("link_body")
    # IO.inspect(server)

    assigns = %{name: server.name, status: server.status}

    ~H"""
    <span class={"status #{@status}"}></span>
    <img src="/images/server.svg" class="w-8 h-8" />
    <%= @name %>
    """
  end

  def render(assigns) do
    ~H"""
    <h1>Servers</h1>
    <.link patch={~p"/servers/new"}>Add Server</.link>
    <div id="servers">
      <div class="sidebar">
        <nav>
          <%= for server <- @servers do %>
            <div id={server.name}>
              <.link
                patch={~p"/servers?name=#{server.name}"}
                class={if server == @selected_server, do: "active"}
              >
                <.link_body server={server} />
              </.link>
            </div>
          <% end %>
        </nav>
      </div>
      <div class="main">
        <div class="wrapper">
          <%= if @live_action == :new do %>
            <.form
              :let={form}
              for={@changeset}
              phx-submit="save"
              phx-change="validate"
              phx-hook="StashForm"
              id="new-server-form"
            >
              <.input
                label="name"
                field={form[:name]}
                errors={form[:name]}
                phx-debounce={2000}
              />
              <.input
                label="framework"
                field={form[:framework]}
                errors={form[:framework]}
                phx-debounce={2000}
              />
              <.input
                label="Size (MB)"
                field={form[:size]}
                errors={form[:size]}
                phx-debounce={2000}
              />
              <.input
                label="Git Repo"
                field={form[:git_repo]}
                errors={form[:git_repo]}
                phx-debounce={2000}
              />
              <button type="submit" phx-disable-with="Saving...">
                Save
              </button>
              <.link patch={~p"/servers"}>Cancel</.link>
            </.form>
          <% else %>
            <div class="card">
              <div class="header">
                <h2><%= @selected_server.name %></h2>
                <button
                  phx-click="toggle_status"
                  phx-value-id={@selected_server.id}
                  phx-disable-with="Saving..."
                  class={@selected_server.status}
                >
                  <%= @selected_server.status %>
                </button>
              </div>
              <div class="body">
                <div class="row">
                  <div class="deploys">
                    <img src="/images/deploy.svg" class="w-8 h-8" />
                    <span>
                      <%= @selected_server.deploy_count %> deploys
                    </span>
                  </div>
                  <span>
                    <%= @selected_server.size %> MB
                  </span>
                  <span>
                    <%= @selected_server.framework %>
                  </span>
                </div>
                <h3>Git Repo</h3>
                <div class="repo">
                  <%= @selected_server.git_repo %>
                </div>
                <h3>Last Commit</h3>
                <div class="commit">
                  <%= @selected_server.last_commit_id %>
                </div>
                <blockquote>
                  <%= @selected_server.last_commit_message %>
                </blockquote>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
