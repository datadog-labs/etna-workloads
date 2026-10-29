# Rationale

The fix's `IsReadOnly` signature change (int viewOk -> Trigger*) is already in 3.54.1, so I reverted the behaviour in place.

- `src/delete.c` `sqlite3IsReadOnly`: the view check is back to "any trigger present means the view is OK" (`pTrigger==0 && IsView(pTab)`). This reverses fix hunk (1). A RETURNING pseudo-trigger (`bReturning`, sole entry) now counts as an INSTEAD OF trigger, which is how the old `viewOk = pTrigger?1:0` / `tmask` behaved.
- `src/trigger.c` `sqlite3TriggerColmask`: removed the `IsView(pTab)` early return of 0xffffffff. This reverses fix hunk (2), so not all view columns are generated.
- `src/where.c` `constructAutomaticIndex`: removed the `IsView` branch, so the automatic index covers only `colUsed` columns. This reverses fix hunk (3). 3.54.1's form was `ALLBITS & ~idxCols`.

Not reverted: the `assert(... || pParse->nErr>0)` in insert.c, which is not part of the bug mechanism.

## Oracle failures
`./check.sh` fails window1-73.2, 73.4, 73.6 and 73.7. The UPDATE ... RETURNING on a view with no INSTEAD OF trigger, or with only an UPDATE trigger, no longer gives the correct result or the "cannot modify t2 because it is a view" error.
