# Rationale

The commit being reverted (651d005e76bc) removed `abs()` from the plural/singular decisions. REL_18_6 therefore has the `value`-based form. This change puts the `abs()` form back, so "-1" is printed with a singular unit.

All hunks are in `src/backend/utils/adt/datetime.c` and trace to the hunks of the same file in fix_impl.patch:

- `AddPostgresIntPart`: `(value != 1)` is now `(abs(value) != 1)`. This matches the first hunk of fix_impl.patch, reversed.
- `AddVerboseIntPart`: `(value == 1)` is now `(abs(value) == 1)`. This matches the second hunk, reversed.
- `EncodeInterval`: removed the comment `/* We output "ago", not negatives, so use abs(). */`. This matches the third hunk, reversed. It is a comment-only change.

Effect: with `abs()` the unit is singular for a value of -1. The interval tests expect `-1 years`, `-1 days` and similar, so the output now differs from what they expect.

I did not change the ecpg or libpq hunks of fix_impl.patch. They are not exercised by the oracle.

Failing oracle case: `src/test/regress||interval`
