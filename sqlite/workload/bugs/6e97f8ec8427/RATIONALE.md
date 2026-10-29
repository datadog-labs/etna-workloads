# Rationale

The fix turned `sqlite3VdbePureFuncOnly()` (void; it only set an error) into
`sqlite3NotPureFunc()`, which returns 0 after raising the error so that the
date/time callers in date.c skip the non-deterministic code (`now`,
`localtime`, `utc`). It also gave CHECK constraints their own context through
`iSelfTab`. The ckBase/iSelfTab merge has already been done in 3.54.1 and can't
be reversed cleanly, so I reverted only the return-value hunk.

## Change: src/vdbeaux.c, sqlite3NotPureFunc()
Removed `return 0;` in the OP_PureFunc branch, so the function always returns 1
after raising the error.
This reverses the hunk in vdbeaux.c/date.c that added the `return 0` / `return 1`
protocol. Before the fix the helper only recorded the error and the callers
carried on regardless (`now && PureFuncOnly(...)`, with the date code
continuing). Every date.c call site (`&& sqlite3NotPureFunc(ctx)`) now behaves
as it did with the old void helper: the error is set, then the date is
computed from the current time anyway and the result overwrites the error.

## Oracle failures
test/date2.test: 14 cases fail (date2-110, 140, 210, 310, 410, 430, 510, 520,
600, 603, 604, 610, 612, date3-620). Each expects "non-deterministic use of
X() in a CHECK constraint / an index / a generated column" and gets a
julianday or date value instead (for example `[1 2461341.77...]`).
