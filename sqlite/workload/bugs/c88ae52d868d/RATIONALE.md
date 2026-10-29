# Rationale

## Change
`tree/src/pager.c`, `sqlite3PagerDontWrite()`: removed the `!pPager->tempFile &&` term from the condition. This reverses the single implementation hunk of the fix, which applied cleanly in the current code. The explanatory comment was left in place.

Without the check, PGHDR_DONT_WRITE is set on dirty pages of temp databases. A page that was already dirty at the start of a transaction is then not written out under cache pressure, so a later ROLLBACK reads back stale data.

## Oracle failure
`tempdb2-1.4` fails: expected `1 1 1`, got `1 0 0`. The update made in 1.2 is lost after the rollback in 1.3. The other six cases still pass.
