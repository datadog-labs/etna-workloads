# Rationale

Fix hunk reversed: the `constInsert()` hunk in `src/select.c`, which added a loop
that returns early when the same column (`iTable`/`iColumn`) is already in
`pConst->apExpr`. In version-3.54.1 the function has a different signature and
extra filters, but the same loop still exists, marked "2018-10-25 ticket [cf5ed20f]".
I removed that loop and the `int i;` declaration it used. Nothing else changed.

Without the check, `WHERE x.b=1 AND x.b=1` inserts column `x.b` twice. The
constant-propagation pass then substitutes the column more than once, which gives
an incorrect join result.

The other fix hunks only changed a comment, the manifest files and the test, so
there was nothing to revert there.

## Oracle failure

`whereL-400` fails. It expects `{}` and gets `{1}`. The other 27 cases pass.
