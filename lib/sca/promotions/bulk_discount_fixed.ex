defmodule Sca.Promotions.BulkDiscountFixed do
  @moduledoc "Represents a Bulk Discount Fixed Price rule."
  defstruct [:product_code, parameters: %{fixed_price: nil, min_qty: nil}]

  @type t :: %__MODULE__{
          product_code: String.t(),
          parameters: %{fixed_price: Decimal.t(), min_qty: non_neg_integer()}
        }
end

# The COO, though, likes low prices and wants people buying strawberries to get a price
# discount for bulk purchases. If you buy 3 or more strawberries, the price should drop to £4.50
# per strawberry.
defimpl Sca.Discount.Rule,
  for: Sca.Promotions.BulkDiscountFixed do
  alias Sca.Promotions.BulkDiscountFixed
  alias Sca.Cart.{Product, Checkout}

  def apply_rule(
        %BulkDiscountFixed{
          product_code: product_code,
          parameters: %{fixed_price: fixed_price, min_qty: min_qty}
        },
        cart
      ) do
    Enum.map(cart, fn
      %Checkout{product: %Product{code: ^product_code}, amount: amount} = item ->
        if amount >= min_qty do
          total = Decimal.mult(fixed_price, Decimal.new(amount)) |> Decimal.round(2)
          %Checkout{item | total: total}
        else
          item
        end

      item ->
        item
    end)
  end
end
