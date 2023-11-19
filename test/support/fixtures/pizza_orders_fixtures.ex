defmodule LiveViewStudio.PizzaOrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewStudio.PizzaOrders` context.
  """

  @doc """
  Generate a pizza_order.
  """
  def pizza_order_fixture(attrs \\ %{}) do
    {:ok, pizza_order} =
      attrs
      |> Enum.into(%{
        pizza: "some pizza",
        username: "some username"
      })
      |> LiveViewStudio.PizzaOrders.create_pizza_order()

    pizza_order
  end
end
