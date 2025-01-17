defmodule Sca.Discount do
  @moduledoc """
  A factory for dynamically creating discount rule structs based on the type.
  """
  alias Sca.Cart.Checkout

  # In this section, it was decided to use a protocol instead of @behaviour to allow
  # functions to be added externally to the main source whenever needed, enabling the
  # implementation of polymorphism to a relative extent.
  # This feature can almost be considered and utilized as a plugin-based pattern.
  defprotocol Rule do
    @doc "Applies the discount rule to the cart"
    @spec apply_rule(struct(), [Checkout.t()]) :: [Checkout.t()]
    def apply_rule(rule, cart)
  end

  @doc """
  This function generates the required structs for invoking the protocol based on the provided rules.
  It is important to note that it should be implemented according to the strategy and security
  considerations, with an additional validation layer required beforehand.
  """
  @spec create_rule(%{:type => binary(), optional(any()) => any()}) :: struct()
  def create_rule(%{type: type} = data) do
    # Based on the strategy it can change to Module.safe_concat
    module_name =
      Module.concat(["Sca.Promotions", Macro.camelize(type)])

    struct(module_name, Map.delete(data, :type))
  end
end
