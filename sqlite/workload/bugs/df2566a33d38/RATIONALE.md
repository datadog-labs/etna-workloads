# Rationale

Fix hunk reversed: `pager_end_transaction(pPager, hasMaster)` -> `zeroJournalHdr(pPager, hasMaster)`
(persistent-journal mode truncates the journal to 0 when a master/super-journal was used,
so a stale journal tail / master-journal pointer cannot survive).

In 3.54.1 this is `src/pager.c` in `pager_end_transaction()`:
`zeroJournalHdr(pPager, hasSuper||pPager->tempFile)` -> `zeroJournalHdr(pPager, pPager->tempFile)`.
Before the fix the multi-file commit only zeroed the 28-byte header instead of
truncating, leaving the journal non-empty after a multi-file transaction.

Only this hunk was reverted (the writeSuper truncate and btreeCopyFile hunks are untouched).

Oracle cases failing: jrnlmode-2.2 and jrnlmode-2.4 (test.db-journal size is nonzero
rather than 0 after a multi-file commit in persist mode), and jrnlmode-5.11.
