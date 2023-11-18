defmodule LiveViewStudioWeb.FilterLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Boats
  import Phoenix.HTML.Form

  def mount(_params, _session, socket) do
    socket = assign_defaults(socket)
    {:ok, socket, temporary_assigns: [boats: []]}
  end

  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    params = [type: type, prices: prices]
    boats = Boats.list_boats(params)
    # socket = assign(socket, params ++ [boats: boats])
    socket = assign(socket, [{:boats, boats} | params])
    {:noreply, socket}
  end

  def handle_event("clear-filters", _params, socket) do
    socket = assign_defaults(socket)
    {:noreply, socket}
  end

  defp assign_defaults(socket) do
    assign(socket, boats: Boats.list_boats(), type: "", prices: [])
  end

  defp dom_id(boat) do
    "boat-#{boat.id}"
  end

  defp price_checkbox(assigns) do
    assigns = Enum.into(assigns, %{})

    ~H"""
    <input
      type="checkbox"
      id={@price}
      name="prices[]"
      value={@price}
      checked={@checked}
    />
    <label for={@price}><%= @price %></label>
    """
  end

  defp type_options do
    [
      "All Types": "",
      Fishing: "fishing",
      Sporting: "sporting",
      Sailing: "sailing"
    ]
  end
end

# mix phx.gen.context Boats Boat boats image:string model:string price:string type:string
# mix ecto.migrate
