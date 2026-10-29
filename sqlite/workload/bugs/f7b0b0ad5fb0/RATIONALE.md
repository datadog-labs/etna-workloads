# Rationale

Fix b73fb0bd64: NATURAL/USING join terms were built as `alias.col = alias.col`
TK_ID/TK_DOT name expressions, so the tables were identified by name or alias
instead of FROM-list position. Self-joins such as `t1 JOIN t1 USING(a)` or
`t1 NATURAL JOIN t1` resolve both sides to the same table.

The fix replaced addWhereTerm()'s name-based expressions with
sqlite3CreateColumnExpr(). In 3.54.1 that logic is inline in
sqlite3ProcessJoin() (src/select.c), so the hunks cannot be reversed directly.

Changes (src/select.c only):
- Added `joinColumnByName()`, which builds `TK_DOT(TK_ID(alias-or-name), TK_ID(col))`
  as the old addWhereTerm() did (reverses the sqlite3CreateColumnExpr hunk).
- In the USING loop, the first left-side reference (pE1) and the right-side
  reference (pE2) use it instead of sqlite3CreateColumnExpr()
  (reverses the select.c addWhereTerm / sqliteProcessJoin hunks).
- `pEq->w.iJoin = pRight->iCursor` replaces `pE2->iTable`, as the old code used
  `pRight->iCursor` (a TK_DOT node has no cursor yet).
- The coalesce() path for RIGHT/FULL JOIN still uses positional columns, since
  it did not exist in 2009.

Oracle failures (test/join.test): join-11.2 (`SELECT a FROM t1 JOIN t1 USING (a)`)
and join-11.4 (`SELECT * FROM t1 NATURAL JOIN t1`) return wrong results/errors
because both names resolve to the same table instance.
