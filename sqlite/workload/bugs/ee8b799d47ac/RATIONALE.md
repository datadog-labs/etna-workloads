# Rationale

Fix (CVS 6390) made `hasHotJournal()` open the journal and treat it as hot only if its first byte is non-zero (bugs #3745, #3751). Before, any existing journal, when the db was non-empty and unlocked, counted as hot.

## Change: src/pager.c, hasHotJournal()
In the `nPage>0` branch, I removed the open/read-first-byte logic (including the CANTOPEN fallback) and set `*pExists = 1`. This reverses the fix's added "check first byte of journal is non-zero" block. The `jrnlOpen` handling and the `nPage==0` deletion path are untouched. The fix's other hunk (dropping `SQLITE_OPEN_EXCLUSIVE` in pager_open_journal) is not reintroduced; it is unrelated to the hot-journal check.

## Oracle failure
`jrnlmode2-1.6` fails: with a persistent journal (zeroed header) left in place while another connection holds a SHARED lock, `db2` wrongly sees a hot journal and gets `1 {database is locked}` instead of `0 {1 2 3 4}` (bug #3745).
