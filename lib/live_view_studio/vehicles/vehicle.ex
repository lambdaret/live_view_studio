defmodule LiveViewStudio.Vehicles.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicles" do
    field :color, :string
    field :make, :string
    field :model, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:color, :make, :model])
    |> validate_required([:color, :make, :model])
  end
end
