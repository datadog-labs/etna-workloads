Casts text to NUMERIC: `CAST('1.0' AS NUMERIC)` and `CAST('123e+5' AS NUMERIC)` should
return integers (1 and 12300000). The buggy shell returns REAL (1.0, 12300000.0).
