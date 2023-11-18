defmodule LiveViewStudioWeb.SalesDashboardLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Sales
  alias Phoenix.HTML.Form

  def mount(_params, _session, socket) do
    options = [
      "1s": 1,
      "5s": 5,
      "15s": 15,
      "30s": 30,
      "60s": 60
    ]

    socket =
      socket
      |> assign(refresh: 1, timer: nil, options: options)
      |> schedule_refresh()
      |> assign_stats()

    {:ok, socket}
  end

  def schedule_refresh(socket) do
    if connected?(socket) do
      _ = :timer.cancel(socket.assigns.timer)
      {:ok, timer} = :timer.send_interval(socket.assigns.refresh * 1000, :tick)
      assign(socket, timer: timer)
    else
      socket
    end
  end

  def assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction(),
      last_updated_at: Timex.local()
    )
  end

  def handle_info(:tick, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  def handle_event("refresh", _unsigned_params, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  def handle_event("update-time", %{"refresh" => refresh}, socket) do
    refresh = String.to_integer(refresh)

    socket =
      socket
      |> assign(refresh: refresh)
      |> schedule_refresh()

    {:noreply, socket}
  end

  # attr :refresh, :integer, required: true
  # attr :options, :list, required: true

  # def options(assigns) do
  #   Phoenix.HTML.Form.options_for_select(assigns.options, assigns.refresh)

  #   # ~H"""
  #   # <%= for {txt, val} <- @options do %>
  #   #   <option value={val} {if val == @refresh, do: "selected", else: ""}>
  #   #     <%= txt %>
  #   #   </option>
  #   # <% end %>
  #   # """
  # end
end

# {[if val == @refresh, do: "selected", else: ""]}
