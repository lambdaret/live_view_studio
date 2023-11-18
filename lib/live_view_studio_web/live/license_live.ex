defmodule LiveViewStudioWeb.LicenseLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Licenses
  import Number.Currency

  def render(assigns) do
    ~H"""
    <h1>Team License</h1>
    <div id="license">
      <div card="card">
        <div class="content">
          <div class="seats">
            <img src="images/license.svg" class="w-32 h-32" />
            <span>
              Your license is currently for <.seats seats={@seats} />
            </span>
          </div>

          <p class="mb-4 font-semibold text-indiigo-800">
            <%= @time_remaining %> left to save 20%
          </p>
        </div>

        <form phx-change="update">
          <input type="range" name="seats" min="1" max="10" value={@seats} />
        </form>

        <div class="amount">
          <%= number_to_currency(Licenses.calculate(@seats)) %>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    IO.inspect("mount")
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)
    expiration_time = Timex.shift(Timex.now(), hours: 1)
    seats = 1

    socket =
      assign(socket,
        seats: seats,
        # amount: Licenses.calculate(seats),
        expiration_time: expiration_time,
        time_remaining: time_remaining(expiration_time)
      )

    {:ok, socket}
  end

  def handle_event("update", %{"seats" => seats}, socket) do
    seats = String.to_integer(seats)

    socket =
      assign(socket,
        seats: seats
        # amount: Licenses.calculate(seats)
      )

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    # IO.inspect("tick")
    expiration_time = socket.assigns.expiration_time
    socket = assign(socket, time_remaining: time_remaining(expiration_time))
    {:noreply, socket}
  end

  def time_remaining(expiration_time) do
    # IO.inspect("time_remaining")

    Timex.Interval.new(from: Timex.now(), until: expiration_time)
    |> Timex.Interval.duration(:seconds)
    |> Timex.Duration.from_seconds()
    |> Timex.format_duration(:humanized)
  end

  attr :seats, :integer, required: true
  def seats(%{seats: 1} = assigns), do: ~H"<strong>1</strong> seat"
  def seats(assigns), do: ~H"<strong><%= @seats %></strong> seats"
end
