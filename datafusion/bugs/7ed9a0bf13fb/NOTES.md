repro.sql calls `power(decimal, int)` three ways (negative exponent, a 10th power that overflows the unscaled integer, and 2.5^4 at low scale).
Clean build: `power` always returns Float64 (0.03125, 9536.7431640625, 39.0625).
Buggy build: it keeps the decimal code path. It returns Decimal128 with truncated values (0 and 3.9) and fails with "Arithmetic overflow: Cannot raise base 25000 to exp 10".
