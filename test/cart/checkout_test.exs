defmodule ScaTest.Cart.CheckoutTest do
  use ExUnit.Case

  use ExUnit.Case
  alias Sca.Cart.Checkout
  alias Sca.Discount
  alias Sca.Cart.Product

  setup do
    green_tea = %Product{code: "GR1", name: "Green Tea", price: Decimal.new("3.11")}
    strawberries = %Product{code: "SR1", name: "Strawberries", price: Decimal.new("5.00")}
    coffee = %Product{code: "CF1", name: "Coffee", price: Decimal.new("11.23")}

    discounts = [
      %{type: "buy_one_get_one_free", product_code: "GR1"},
      %{
        type: "bulk_discount_fixed",
        product_code: "SR1",
        parameters: %{fixed_price: "4.50", min_qty: 3}
      },
      %{
        type: "take_three_pay_two",
        product_code: "CF1",
        parameters: %{pay_for: 2, min_qty: 3}
      }
    ]

    rules = Enum.map(discounts, &Discount.create_rule/1)
    {:ok, green_tea: green_tea, strawberries: strawberries, coffee: coffee, rules: rules}
  end

  test "Basket: GR1,SR1,GR1,GR1,CF1 - Total price expected: £22.45", %{
    green_tea: green_tea,
    strawberries: strawberries,
    coffee: coffee,
    rules: rules
  } do
    cart = [Checkout.new(green_tea, 3), Checkout.new(strawberries, 1), Checkout.new(coffee, 1)]
    total_price = Checkout.checkout(rules, cart)
    assert total_price == Decimal.new("22.45")
  end

  test "Basket: GR1,GR1 - Total price expected: £3.11", %{green_tea: green_tea, rules: rules} do
    cart = [Checkout.new(green_tea, 2)]
    total_price = Checkout.checkout(rules, cart)
    assert total_price == Decimal.new("3.11")
  end

  test "Basket: SR1,SR1,GR1,SR1 - Total price expected: £16.61", %{
    green_tea: green_tea,
    strawberries: strawberries,
    rules: rules
  } do
    cart = [Checkout.new(strawberries, 3), Checkout.new(green_tea, 1)]
    total_price = Checkout.checkout(rules, cart)
    assert total_price == Decimal.new("16.61")
  end

  test "Basket: GR1,CF1,SR1,CF1,CF1 - Total price expected: £30.57", %{
    green_tea: green_tea,
    strawberries: strawberries,
    coffee: coffee,
    rules: rules
  } do
    cart = [Checkout.new(green_tea, 1), Checkout.new(coffee, 3), Checkout.new(strawberries, 1)]
    total_price = Checkout.checkout(rules, cart)
    assert total_price == Decimal.new("30.57")
  end

  # Extra tests
  test "Basket: GR1,GR1,GR1 - Total price expected: £6.22", %{green_tea: green_tea, rules: rules} do
    cart = [Checkout.new(green_tea, 3)]
    total_price = Checkout.checkout(rules, cart)
    # Buy One Get One Free applies
    assert total_price == Decimal.new("6.22")
  end

  test "Basket: SR1,SR1 - Total price expected: £10.00", %{
    strawberries: strawberries,
    rules: rules
  } do
    cart = [Checkout.new(strawberries, 2)]
    total_price = Checkout.checkout(rules, cart)
    # No bulk discount applies
    assert total_price == Decimal.new("10.00")
  end

  test "Basket: CF1,CF1,CF1 - Total price expected: £22.46", %{coffee: coffee, rules: rules} do
    cart = [Checkout.new(coffee, 3)]
    total_price = Checkout.checkout(rules, cart)
    # Take Three Pay Two applies
    assert total_price == Decimal.new("22.46")
  end

  test "Basket: SR1,SR1,SR1,SR1 - Total price expected: £18.00", %{
    strawberries: strawberries,
    rules: rules
  } do
    cart = [Checkout.new(strawberries, 4)]
    total_price = Checkout.checkout(rules, cart)
    # Bulk discount applies for all items
    assert total_price == Decimal.new("18.00")
  end

  test "Basket: Empty cart - Total price expected: £0.00", %{rules: rules} do
    cart = []
    total_price = Checkout.checkout(rules, cart)
    # Empty cart
    assert total_price == Decimal.new("0")
  end

  test "Basket: CF1,CF1 - Total price expected: £22.46", %{coffee: coffee, rules: rules} do
    cart = [Checkout.new(coffee, 2)]
    total_price = Checkout.checkout(rules, cart)
    # No discount applies for less than 3 coffees
    assert total_price == Decimal.new("22.46")
  end

  test "Basket: Empty ruls and cart - Total price expected: £0.00" do
    total_price = Checkout.checkout([], [])
    assert total_price == Decimal.new("0")
  end

  test "Basket: GR1,GR1,GR1 :: Empty ruls - Total price expected: £9.33", %{green_tea: green_tea} do
    cart = [Checkout.new(green_tea, 3)]
    total_price = Checkout.checkout([], cart)
    # No discount applies for Empty ruls
    assert total_price == Decimal.new("9.33")
  end
end
