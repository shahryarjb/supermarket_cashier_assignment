defmodule Sca.Promotions.TakeThreePayTwo do
  @moduledoc "Represents a Take Three Pay Two discount rule."

  defstruct [:product_code, parameters: %{pay_for: nil, min_qty: nil}]

  @type t :: %__MODULE__{
          product_code: String.t(),
          parameters: %{pay_for: non_neg_integer(), min_qty: non_neg_integer()}
        }
end

# The CTO is a coffee addict. If you buy 3 or more coffees, the price of all coffees should drop
# to two thirds of the original price.
defimpl Sca.Discount.Rule,
  for: Sca.Promotions.TakeThreePayTwo do
  alias Sca.Promotions.TakeThreePayTwo
  alias Sca.Cart.{Product, Checkout}

  def apply_rule(
        %TakeThreePayTwo{
          product_code: product_code,
          parameters: %{pay_for: pay_for, min_qty: min_qty}
        },
        cart
      ) do
    Enum.map(
      cart,
      fn
        %Checkout{product: %Product{code: ^product_code}, amount: amount} = item ->
          if amount >= min_qty do
            effective_items = div(amount * pay_for, min_qty)

            total =
              Decimal.mult(item.product.price, Decimal.new(effective_items)) |> Decimal.round(2)

            %Checkout{item | total: total}
          else
            item
          end

        item ->
          item
      end
    )
  end
end
