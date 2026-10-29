# Rationale: ticket #2450 (quote identifiers when expanding `*`)

Fix: `setQuotedToken()` double-quoted and escaped (`%w`) expanded column/table
names so that re-parsing them as identifiers recovered the original name.
Pre-fix, names were inserted raw, so a column named `"cb"` (with literal quote
characters) was misinterpreted as a quoted identifier.

In 3.54.1 `*` expansion (`selectExpander` in src/select.c) builds `TK_ID`
nodes with `sqlite3Expr()`, which stores the name as already-dequoted
(`dequote=0`). The `%w`/`setQuotedToken` mechanism no longer exists, so I
restored the pre-fix semantics, "expanded name is treated as quotable text",
by building the same nodes with `sqlite3ExprAlloc(..., dequote=1)`:

- `pRight` (column name) and `pLeft` (table name) in `selectExpander`: reverses
  the `setQuotedToken(&pRight->token, zName)` / `setQuotedToken(&pLeft->token, zTabName)`
  hunks. Unquoted names starting with a quote char get dequoted, as when
  the raw name was re-parsed.

The printf.c `%w` hunk and the OOM check hunk are supporting pieces with no
separate behavior to revert.

## Oracle results (test/tkt2450.test)
- tkt2450-2 (`SELECT * FROM "t a"`) returns `cb` instead of `1`
  (column `"cb"` is dequoted to `cb` and resolves to a string literal fallback).
- tkt2450-3 (`SELECT "t a".* ...`) fails likewise; the join case errors with `no such column: main.t a.cb`.
- tkt2450-1 still passes (no star expansion).
