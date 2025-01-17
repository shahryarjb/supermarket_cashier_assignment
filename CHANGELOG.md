# Changelog for Sca 0.0.1

# Changelog

## Added
- Introduced the **`Discount`** Creator module to manage dynamic discount rule creation and cart updates.
- Implemented the **`promotions`** module with individual `defimpl` rules for flexible discount application:
  - **Buy-One-Get-One-Free (Green Tea)**: Applies to `GR1`.
  - **Bulk Discount (Strawberries)**: Reduces price to £4.50 for `SR1` when buying 3 or more.
  - **Take Three, Pay Two (Coffee)**: Reduces total price to two-thirds for `CF1` when buying 3 or more.

## Updated
- Enhanced **README**:
  - Added project overview, purpose, and structure details.
  - Highlighted the modular design of `cart`, `discount`, and `promotions` sections.
- Added inline comments explaining the strategy behind each promotion rule for better maintainability.

## Changed
- Refactored **checkout logic** to prioritize flexibility in applying pricing rules and reduce dependency on the database.

## Removed
- Database dependencies: All data is now provided as lists within test files, reflecting the project's practice-oriented purpose.
