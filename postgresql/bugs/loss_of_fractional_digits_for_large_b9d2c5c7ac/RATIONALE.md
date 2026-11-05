# Rationale

## src/backend/utils/adt/cash.c, cash_numeric()
Traces to the fix.patch hunk that added the `numeric_round(numeric_scale, fpoint)` call
(with its comment about select_div_scale()) before the `numeric_div`. I removed that call
(and its comment). Without a dscale of at least fpoint on the divisor, for money values near
INT64_MAX select_div_scale() can choose a result scale of 0, so the quotient loses its
fractional digits.

## Failing oracle cases
- src/test/regress||money (confirmed FAIL in oracle run; 1/1 failing)
