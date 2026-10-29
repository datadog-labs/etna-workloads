repro.sh builds an auto-vacuum db, adds rows, then restores the old header page-count (offset 28) and
change counter / version-valid-for (offset 92), as the test's sql36231 helper does, so the in-header size
is stale and ignored. It then runs `.backup` and `PRAGMA integrity_check` on the copy.

Clean shell: backup rewrites the header size, integrity_check prints `ok`.
Buggy shell (injection drops that write in backupOnePage): the copy fails with
"database disk image is malformed" / "invalid page number" errors, exit status 1.
