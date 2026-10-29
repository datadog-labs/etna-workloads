# Rationale

## Change
`tree/src/pager.c`, in `sqlite3PagerCommitPhaseTwo()`, the exclusive-mode / PERSIST-journal no-op branch (`eState==PAGER_WRITER_LOCKED && exclusiveMode && journalMode==PERSIST`):

    assert( pPager->journalOff==JOURNAL_HDR_SZ(pPager) || !pPager->journalOff );
    ->
    assert( pPager->journalOff==JOURNAL_HDR_SZ(pPager) );

This reverses the fix's only implementation hunk, which relaxed that assert to also accept `journalOff==0`. In 3.54.1 the condition is written with `eState==PAGER_WRITER_LOCKED` instead of the old `dbModified==0`, but it is the same branch and the same assert. Since the journal is opened lazily, `journalOff` is 0 when `BEGIN EXCLUSIVE; COMMIT;` runs, so the strict assert is wrong.

## Oracle failures
`pager1-20.2.2` (`BEGIN EXCLUSIVE; COMMIT;` in exclusive locking mode with a persist journal) aborts with `Assertion 'pPager->journalOff==JOURNAL_HDR_SZ(pPager)' failed`. The test file stops there, so later cases in pager1.test are not run. This is the failure the fix's added test guards against. It is an assert-only bug, so it needs an assert-enabled build.
