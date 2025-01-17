defmodule Sca.Promotions.BuyOneGetOneFree do
  @moduledoc "Represents a Buy-One-Get-One-Free discount rule."
  defstruct [:product_code]

  @type t :: %__MODULE__{product_code: String.t()}
end

defimpl Sca.Discount.Rule,
  for: Sca.Promotions.BuyOneGetOneFree do
  alias Sca.Promotions.BuyOneGetOneFree
  alias Sca.Cart.{Product, Checkout}

  def apply_rule(%BuyOneGetOneFree{product_code: product_code}, cart) do
    Enum.map(cart, fn
      %Checkout{product: %Product{code: ^product_code}, amount: amount} = item ->
        free_items = div(amount, 2)

        total =
          Decimal.mult(item.product.price, Decimal.new(amount - free_items)) |> Decimal.round(2)

        %Checkout{item | total: total}

      item ->
        item
    end)
  end
end
