Reproducer: enables `parse_float_as_decimal` so `1e4` becomes a negative-scale Decimal128, then runs `log` on it (scalar, and array via VALUES with ORDER BY).
Clean: all queries return correct values. Buggy: the array-input queries (`log(value) from (values (1e3),...)`, `log(base, 1e4)` over a VALUES table) fail with
"Optimizer rule 'simplify_expressions' failed ... Negative scale is not supported" (internal error), because log's simplify no longer skips negative-scale decimals.
