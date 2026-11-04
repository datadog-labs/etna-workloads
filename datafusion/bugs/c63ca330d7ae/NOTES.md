Reproducer: repro.sql runs ROUND on decimals whose rounding carries into a new digit (99 at -1, 999.9, 99.99, and a max-precision decimal(38,1)).
Clean build widens precision / reduces scale (e.g. Decimal128(3,0) 100, 1000, 100). The buggy build keeps the input type, so results are wrong, e.g. round(99::decimal(2,0), -1) returns 10 instead of 100, and 999.9 rounds to 100.0 instead of 1000.
