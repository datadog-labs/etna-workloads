# Rationale

Fix hunk (src/func.c, sqlite3QuoteValue): the fix added the `0` flag to the
quote() float formats (`%!.15g` -> `%!0.15g`, `%!.20e` -> `%!0.20e`). In
printf.c the `0` (flag_zeropad) flag makes +/-Inf render as `9.0e+999`
instead of `Inf`/`-Inf`.

In 3.54.1 the two-step 15g/20e logic was replaced by a single
`"%!0.17g"` call in sqlite3QuoteValue (src/func.c). I dropped the `0` flag
(`"%!.17g"`), the same omission the fix corrected. printf.c is unchanged.

Result: quote(4.2e+859) yields `Inf` and quote(-7.8e+904) yields `-Inf`.

Oracle failure: test/func.test func-16.2 (expected `9.0e+999 -9.0e+999`).
