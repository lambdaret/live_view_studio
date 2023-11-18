defmodule LiveViewStudio.Repo do
  use Ecto.Repo,
    otp_app: :live_view_studio,
    adapter: Ecto.Adapters.Postgres
end

#  mix phx.gen.context Volunteers Volunteer volunteers checked_out:boolean name:string phone:string
