# Rationale

In 3.54.1 the TK_IF_NULL_ROW wrapper already carries its own flag, EP_IfNullRow (the fix's sqliteInt.h hunk), and sqlite3ExprAffinity already tests `EP_Skip|EP_IfNullRow` (the fix's first expr.c hunk). So I reverted only the part that made the bug visible: the wrapper is marked EP_Skip again, and the skip helpers go through it again.

- `src/select.c` substExpr: `ifNullRow.flags = EP_IfNullRow` is now `EP_Skip`. This reverses the select.c hunk of the fix. sqlite3ExprSkipCollate then treats the IF_NULL_ROW wrapper like a COLLATE.
- `src/expr.c` sqlite3ExprSkipCollate: the assert allows TK_IF_NULL_ROW again. This reverses the fix's second expr.c hunk.
- `src/expr.c` sqlite3ExprSkipCollateAndLikely: the `else` branch follows pLeft for any EP_Skip node, with the assert allowing TK_COLLATE or TK_IF_NULL_ROW. This reverses the third expr.c hunk. The current code has an explicit `TK_COLLATE` test and a `break`, which is the later form of that logic.

## Oracle failures (test/join2.test)

join2-9.10, join2-9.11, join2-10.2 and join2-10.4 fail.

- 9.10 and 9.11 are the fix's own tests. `ccc IS NULL` returns 0 instead of 1 for a LEFT JOIN against a view whose column is `bbb IS 1234`.
- 10.2 and 10.4 return 1 instead of NULL.

In each case the IS NULL / IS comparison skips the IF_NULL_ROW wrapper and loses the NULL-row semantics.
