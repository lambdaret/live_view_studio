defmodule LiveViewStudioWeb.SandboxLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudioWeb.DeliveryChargeComponent
  alias LiveViewStudioWeb.QuoteComponent
  alias LiveViewStudioWeb.SandboxCalculatorComponent

  def mount(_params, _session, socket) do
    {:ok, assign(socket, weight: nil, price: nil, delivery_charge: nil)}
  end

  def render(assigns) do
    ~H"""
    <h1>Build A Sandbox</h1>

    <div id="sandbox">
      <.live_component id={1} module={SandboxCalculatorComponent} />
      <.live_component id={1} module={DeliveryChargeComponent} />

      <%= if @weight do %>
        <.live_component
          id={"#{1}"}
          module={QuoteComponent}
          material="sand"
          weight={@weight}
          price={@price}
          delivery_charge={@delivery_charge}
          color="pink"
        />
      <% end %>
    </div>
    """
  end

  def handle_info({:totals, weight, price}, socket) do
    socket = assign(socket, weight: weight, price: price)

    {:noreply, socket}
  end

  def handle_info({:delivery_charge, delivery_charge}, socket) do
    socket = assign(socket, delivery_charge: delivery_charge)

    {:noreply, socket}
  end
end
