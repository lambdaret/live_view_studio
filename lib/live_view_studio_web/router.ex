defmodule LiveViewStudioWeb.Router do
  use LiveViewStudioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LiveViewStudioWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveViewStudioWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/light", LightLive
    live "/license", LicenseLive
    live "/sales_dashboard", SalesDashboardLive
    live "/search", SearchLive
    live "/flights", FlightsLive
    live "/autocomplete", AutocompleteLive
    live "/filter", FilterLive
    live "/servers", ServersLive
    live "/servers/new", ServersLive, :new
    live "/paginate", PaginateLive
    live "/vehicles", VehiclesLive
    live "/sort", SortLive
    live "/volunteers", VolunteersLive
    live "/infinite-scroll", InfiniteScrollLive
    live "/datepicker", DatePickerLive
    live "/sandbox", SandboxLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveViewStudioWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:live_view_studio, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LiveViewStudioWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
