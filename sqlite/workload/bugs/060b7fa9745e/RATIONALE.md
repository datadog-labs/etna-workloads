# Rationale

Changed one hunk, in `isLikeOrGlob()` in `tree/src/whereexpr.c`. It reverses the
`src/whereexpr.c` hunk of fix.patch.

The fix replaced a lexical test of the pattern prefix with `sqlite3AtoF()` on
both boundary keys. The test was: first char is a digit, whitespace, `+` or `-`,
or last char is `'/'` ('0'-1). That test was the outer guard. The LHS check
(not a TEXT-affinity column, or a virtual table column) sat inside it.

Today's code has the AtoF check (with the `-` special case) under the LHS-only
condition. I put the old lexical test back as an extra `&&` condition on that
LHS condition. The AtoF body is left alone, so it only runs for
digit/space/sign/`'/'` prefixes, as before the fix. A prefix like `.1` or `1e5`
can still parse as a number but is no longer caught, so the LIKE optimization
is applied when it shouldn't be.

## Oracle failures
- `like3-5.410`: `c0 INT UNIQUE COLLATE NOCASE` holding '.1%'; `c0 LIKE '.1%'`
  returns no row, because the range constraint `c0>='.1' AND c0<'.2'` is
  applied with numeric affinity.
- `vtabH-3.5` to `vtabH-3.8`: the `e/` and `e` boundary cases (`'8e/'` LIKE/GLOB)
  now get the range optimization where the fix test expects none.
