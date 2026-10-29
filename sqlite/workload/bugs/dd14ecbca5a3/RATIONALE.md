# Rationale

## Change
`tree/src/btree.c`, `sqlite3BtreeSetPageSize()`: the assert changed from
`assert( !pBt->pCursor );` back to `assert( !pBt->pPage1 && !pBt->pCursor );`.

This reverses the only implementation hunk of the fix, which removed the
`!pBt->pPage1` term. That term is wrong. Inside a transaction that has already
read the schema, page 1 is loaded, and `PRAGMA page_size=N` is a legal no-op
there because the pager ignores the new size. The code around the assert is
unchanged from 2015, so the revert is exact.

## Oracle failures
`test/pagesize.test` pagesize-3.1 (`BEGIN; SELECT * FROM sqlite_master; PRAGMA page_size=2048;`)
aborts with `sqlite3BtreeSetPageSize: Assertion '!pBt->pPage1 && !pBt->pCursor' failed`.
Cases 3.2 and 3.3 never run because the process aborts. This needs an assert-enabled build, which check.sh uses.
