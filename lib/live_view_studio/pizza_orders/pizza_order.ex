defmodule LiveViewStudio.PizzaOrders.PizzaOrder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pizza_orders" do
    field :pizza, :string
    field :username, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pizza_order, attrs) do
    pizza_order
    |> cast(attrs, [:pizza, :username])
    |> validate_required([:pizza, :username])
  end
end
