defmodule Sca.Cart.Product do
  @moduledoc """
  This module is responsible for retrieving and updating products.
  Since the project is built in a minimal state, with functionality and code organization
  being the primary focus, it is not connected to a database.
  """

  defstruct [:code, :name, :price]

  @type t :: %__MODULE__{
          code: String.t(),
          name: String.t(),
          price: Decimal.t()
        }
end
