defmodule LiveViewStudio.Boats.Boat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boats" do
    field :image, :string
    field :model, :string
    field :price, :string
    field :type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(boat, attrs) do
    boat
    |> cast(attrs, [:image, :model, :price, :type])
    |> validate_required([:image, :model, :price, :type])
  end
end
