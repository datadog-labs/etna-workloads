# Rationale

Fix (ticket 1c24a659e6d7f3a1): the schema sanity check after ALTER TABLE ... DROP COLUMN
must not apply the double-quoted-string (DQS) fallback to an identifier naming the dropped
column. Otherwise "b" in `CREATE INDEX x1 ON t1("b")` silently becomes a string literal
and the DROP COLUMN wrongly succeeds.

In 3.54.1 the mechanism was redesigned: `db->init.bDropColumn`/`azInit[0]` no longer exist.
Instead `renameTestSchema()` takes `bNoDQS`, which makes `renameTableTest()` clear
SQLITE_DqsDML/DqsDDL while parsing. The DROP COLUMN call passes `1`.

## Change
`src/alter.c`, `sqlite3AlterDropColumn()`: the post-drop
`renameTestSchema(..., "after drop column", 1)` now passes `0`. This corresponds to the fix
hunk that passes `zCol` to `renameTestSchema` after drop column (the old code passed
nothing, i.e. DQS fallback stayed active). Passing `0` restores that: DQS fallback is active in the check.

## Oracle failures
test/quote.test: quote-3.0, 3.1, 3.2, 3.4 fail. DROP COLUMN succeeds (`0 {}`) instead of
reporting "error in index x1 after drop column: no such column: b".
(3.3 and 3.5 still pass: the `'b'` literal case is unaffected.)
