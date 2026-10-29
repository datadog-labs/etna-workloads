# Rationale

## Hunk changed: `sqlite3PagerCommitPhaseTwo` in `tree/src/pager.c`

Reverses the fix's only implementation hunk. The fix narrowed the no-op early
return from `dbModified==0 && (journalMode!=DELETE || exclusiveMode!=0)` to
`dbModified==0 && exclusiveMode && journalMode==PERSIST`.

In 3.54.1 `dbModified==0` is expressed as `eState==PAGER_WRITER_LOCKED`. I
restored the old, too-broad condition:
`eState==PAGER_WRITER_LOCKED && (journalMode!=DELETE || exclusiveMode!=0)`.
I also added `!pagerUseWal(pPager)`, because WAL did not exist in 2009 and
without it every WAL commit would break, which would be a different bug. I
dropped the journalOff assert, which only holds for the PERSIST case.

With the early return, a read-only-content commit in a non-delete journal mode
(for example truncate) with an active reader skips `pager_end_transaction`.
The RESERVED/EXCLUSIVE lock is then kept after COMMIT.

## Oracle failure
`test/lock.test` lock-7.3 fails. Expected `main shared temp unknown`, got
`main exclusive temp unknown`. The other cases pass.
