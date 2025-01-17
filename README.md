# Sca

This is a practice project for an interview, and thus it is not connected to a database. The data is provided as a list within the test file.

```elixir
def deps do
  [
    {:sca, github: "shahryarjb/supermarket_cashier_assignment"}
  ]
end
```

### Note

The entire process of this project is based on the following three strategies and consists of three main sections: cart, discount, and promotions. The promotions section functions like a plugin, allowing for easy addition and removal.

Efforts have been made to align the strategies to enable seamless modifications in pricing and quantity without requiring significant code changes.

#### BuyOneGetOneFree

> The CEO is a big fan of buy-one-get-one-free offers and of green tea. He wants us to add a
> rule to do this.

#### BulkDiscountFixed

> The COO, though, likes low prices and wants people buying strawberries to get a price
> discount for bulk purchases. If you buy 3 or more strawberries, the price should drop to £4.50
> per strawberry.

#### TakeThreePayTwo

> The CTO is a coffee addict. If you buy 3 or more coffees, the price of all coffees should drop
> to two thirds of the original price.