# Rationale

Fix hunk reversed: the `sqlite3ExprCodeIN` change in `src/expr.c`. The fix made a NULL
LHS go to the empty-RHS check (false) rather than unconditionally to `destIfNull`.
The parse.y hunk (`x IN ()` folded to constants) is still present in 3.54.1 and
still handles the literal empty list, so it is left alone. The remaining hunks are
only the `sqlite3IntTokens` plumbing.

In 3.54.1 the equivalent logic is "Step 2" of `sqlite3ExprCodeIN`. When
`destIfNull!=destIfFalse`, a NULL LHS jumped to `destStep6`, the Rewind of the RHS,
which goes to `destIfFalse` if the RHS is empty. I restored the pre-fix behaviour:
`destStep2 = destIfNull;` always. A NULL LHS now yields NULL even for an empty RHS
table or index. That matches the old unconditional `OP_IsNull r1, destIfNull`.

## Oracle failures
`./check.sh` reports 8 failures of 119: tkt-80e031a00f.7, .8, .11, .12, .15, .16, .19, .20.
These are `SELECT null IN t` / `null NOT IN t` over empty tables (rowid, plain and
unique-index RHS), which return NULL instead of 0 / 1.
