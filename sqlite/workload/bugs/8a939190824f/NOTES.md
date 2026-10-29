Reproducer (repro.sh): on a file database, start a transaction, INSERT, then
`PRAGMA journal_mode=memory` inside the transaction, then COMMIT.
The injection removes the `sqlite3PagerOkToChangeJournalMode()` guard in OP_JournalMode,
so the mode change is wrongly applied mid-transaction. Clean shell: the change is
ignored (reports `delete`), exit 0. Buggy shell: assertion failure in assert_pager_state
(abort, exit 134).
