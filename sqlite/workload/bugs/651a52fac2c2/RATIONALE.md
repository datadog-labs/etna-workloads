# Rationale

Fix (ticket #3636) wrapped the sub-journal write in `subjournalPage()` with a
guard so the sub-journal fd is not used when it is not open (journal_mode=off).

In 3.54.1 the guard is `if( pPager->journalMode!=PAGER_JOURNALMODE_OFF )` in
`subjournalPage()` (src/pager.c). I removed the condition (the block is now
unconditional, `{`), so the sub-journal is written to in journal_mode=off
again, as before the fix. Only that one line changed.

Failing oracle case: savepoint-13.2 (INSERT ... SELECT inside a transaction with
journal_mode=off and a statement sub-journal) hits
`Assertion isOpen(pPager->jfd) || pagerUseWal(pPager)` in subjournalPage;
later 13.x cases are not reached. Without asserts the sub-journal would be
used even though journaling is off.
