repro.sql calls pow/power with an integer base and a float exponent, and with two integer arguments.

- df-clean coerces an integer base to Float64. `pow(10, -2.0)` returns 0.01, `power(2, 0.5)` returns 1.4142135623730951, and `power(10, 2)` returns `100.0` (type Float64).
- df-buggy keeps an Int64 base. `pow(10, -2.0)` fails with "Arithmetic overflow: Exponent -2 in integer computation is out of bounds". `power(2, 0.5)` returns 1 (the exponent is truncated), and `power(10, 2)` returns `100` (type Int64).
