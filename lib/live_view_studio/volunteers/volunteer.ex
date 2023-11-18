defmodule LiveViewStudio.Volunteers.Volunteer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "volunteers" do
    field :checked_out, :boolean, default: false
    field :name, :string
    field :phone, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(volunteer, attrs) do
    volunteer
    |> cast(attrs, [:checked_out, :name, :phone])
    |> validate_required([:checked_out, :name, :phone])
  end
end
