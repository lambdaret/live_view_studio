defmodule LiveViewStudioWeb.VehiclesLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Vehicles
  import Phoenix.HTML.Form

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [vehicles: []]}
  end

  def handle_params(params, _uri, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "10")

    pagination_options = %{page: page, per_page: per_page}
    vehicles = Vehicles.list_vehicles(paginate: pagination_options)

    socket =
      assign(socket, options: pagination_options, vehicles: vehicles)

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    per_page = String.to_integer(per_page)
    %{page: page} = change_per_page(socket.assigns.options, per_page)
    socket = push_patch(socket, to: ~p"/vehicles?page=#{page}&per_page=#{per_page}")
    {:noreply, socket}
  end

  def change_per_page(%{page: page, per_page: per_page}, new_per_page) do
    anchor = (page - 1) * per_page + 1
    new_page = div(anchor, new_per_page) + 1
    %{page: new_page, per_page: new_per_page, anchor: anchor}
  end

  def render(assigns) do
    ~H"""
    <h1>🚙 Vehicles 🚘</h1>
    <div id="vehicles">
      <form phx-change="select-per-page">
        Show
        <select name="per-page">
          <%= options_for_select([5, 10, 15, 20], @options.per_page) %>
        </select>
        <label for="per-page">per page</label>
      </form>

      <div class="wrapper">
        <table>
          <thead>
            <tr>
              <th>
                ID
              </th>
              <th>
                Make
              </th>
              <th>
                Model
              </th>
              <th>
                Color
              </th>
            </tr>
          </thead>
          <tbody>
            <%= for vehicle <- @vehicles do %>
              <tr>
                <td>
                  <%= vehicle.id %>
                </td>
                <td>
                  <%= vehicle.make %>
                </td>
                <td>
                  <%= vehicle.model %>
                </td>
                <td>
                  <%= vehicle.color %>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
        <div class="footer">
          <div class="pagination">
            <%= if @options.page > 1 do %>
              <.link patch={
                ~p"/vehicles?page=#{@options.page - 1}&per_page=#{@options.per_page}"
              }>
                Previous
              </.link>
            <% end %>
            <%= for i <- (@options.page - 2)..(@options.page + 2), i > 0 do %>
              <.link patch={
                ~p"/vehicles?page=#{i}&per_page=#{@options.per_page}"
              }>
                <%= i %>
              </.link>
            <% end %>
            <.link patch={
              ~p"/vehicles?page=#{@options.page + 1}&per_page=#{@options.per_page}"
            }>
              Next
            </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
