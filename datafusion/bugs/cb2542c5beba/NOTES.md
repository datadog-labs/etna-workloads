repro.sql runs the three TRY_CAST overflow queries added to timestamps.slt by the fix: a Timestamp(s) scalar, a DATE scalar, and a Timestamp(s) column, each cast to TIMESTAMP(9).

- df-clean returns NULL for all three.
- df-buggy errors on all three ("Cannot cast ... converted value exceeds the representable i64 range"). Two of them fail in the simplify_expressions optimizer rule.

The cause is that the overflow bounds check ignores `cast_options.safe`.
