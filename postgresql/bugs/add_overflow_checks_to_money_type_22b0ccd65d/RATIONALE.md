# Rationale

All changes are in `src/backend/utils/adt/cash.c`, in the static helpers that fix.patch introduced. They trace to the new-helper hunk ("@@ -86,6 +87,82 @@") and the call-site hunks that route cash_pl, cash_mi, the mul/div functions through them.

- `cash_pl_cash`: back to plain `c1 + c2`; the pg_add_s64_overflow check is gone.
- `cash_mi_cash`: back to plain `c1 - c2`; the pg_sub_s64_overflow check is gone.
- `cash_mul_float8`: back to `(Cash) rint(c * f)`; no NaN/range check, so the cast of an out-of-range float is undefined.
- `cash_div_float8`: back to `(Cash) rint(c / f)`; no NaN/range check. Dividing by zero is not caught here either, since the fix moved that check into float8_div.
- `cash_mul_int64`: back to `c * i`; the pg_mul_s64_overflow check is gone.

`cash_div_int64` was left as is. The INT64_MIN / -1 handling there came from a later fix and is not in this commit.

Together these bring back the silent overflow in money arithmetic. The overflow cases in the money regression test now return wrapped values instead of raising "money out of range".

Oracle case expected to fail: `src/test/regress||money`
