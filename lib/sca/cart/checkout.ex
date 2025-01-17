defmodule Sca.Cart.Checkout do
  @moduledoc """
  This module is responsible for managing the user's selected items and calculating the total price.
  The shopping cart module serves as a connector between the accounting section and,
  in future versions, will also handle sending notifications.
  """

  alias Sca.Cart.Product
  alias Sca.Discount.Rule
  alias Decimal

  defstruct [:product, :amount, :total]

  @type t :: %__MODULE__{
          product: Product.t(),
          amount: non_neg_integer(),
          total: Decimal.t()
        }

  @doc """
  Creates a new ProductCart item.
  """
  @spec new(Product.t(), non_neg_integer()) :: t()
  def new(product, amount) do
    %__MODULE__{
      product: product,
      amount: amount,
      total: Decimal.mult(product.price, Decimal.new(amount))
    }
  end

  @doc """
  Updates the total price of a ProductCart item.
  """
  @spec update_total(t(), Decimal.t()) :: t()
  def update_total(%__MODULE__{} = cart, new_total) do
    %__MODULE__{cart | total: new_total}
  end

  @doc """
  Processes the shopping cart by applying a list of pricing rules and calculates the total price.
  """
  @spec checkout(struct(), [__MODULE__.t()]) :: Decimal.t()
  def checkout(rules, cart) do
    Enum.reduce(rules, cart, fn rule, acc ->
      Rule.apply_rule(rule, acc)
    end)
    |> Enum.reduce(Decimal.new(0), fn %__MODULE__{total: total}, acc ->
      Decimal.add(acc, total)
    end)
  end
end
