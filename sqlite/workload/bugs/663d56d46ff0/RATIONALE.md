# Rationale

Fix hunk (src/vacuum.c): the "cannot VACUUM from within a transaction" check was moved to
the top of sqlite3RunVacuum with an early `return SQLITE_ERROR`. Before the fix it ran after
the flags were saved and jumped to `end_of_vacuum`.

In 3.54.1 I reverted that in `sqlite3RunVacuum`: the early-return check is removed from the
top, and the check is re-added after `pMain = db->aDb[iDb].pBt;` (so the cleanup code, which
now uses pMain, is safe) with `rc = SQLITE_ERROR; goto end_of_vacuum;`.
`end_of_vacuum` sets `db->autoCommit = 1`, which silently ends the user's open transaction,
as in the original bug.

Oracle failures: vacuum-2.1.2 (autocommit is 1 instead of 0 after the failed VACUUM) and
vacuum-2.1.3 (COMMIT then fails: no transaction is active).
