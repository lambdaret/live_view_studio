defmodule LiveViewStudioWeb.PaginateLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Donations
  import Phoenix.HTML.Form

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [donations: []]}
  end

  def handle_params(params, _uri, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")

    pagination_options = %{page: page, per_page: per_page}
    donations = Donations.list_donations(paginate: pagination_options)

    socket =
      assign(socket,
        options: pagination_options,
        donations: donations
      )

    {:noreply, socket}
  end

  def change_per_page(%{page: page, per_page: per_page}, new_per_page) do
    anchor = page * per_page
    new_page = div(anchor, new_per_page) + 1
    %{page: new_page, per_page: new_per_page}
  end

  defp expires_class(donation) do
    if Donations.almost_expired?(donation), do: "eat-now", else: "fresh"
  end
end

# mix phx.gen.context Donations Donation donations days_until_expires:integer emoji:string item:string quantity:integer
# mix ecto migrate
