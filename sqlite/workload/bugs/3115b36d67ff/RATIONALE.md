# Rationale

## Changed: tree/src/backup.c, sqlite3_backup_step()
Reverses the second fix hunk. The fix extended the SQLITE_READONLY check from
`destMode==WAL && pgszSrc!=pgszDest` to also cover an in-memory destination
(`sqlite3PagerIsMemdb(pDestPager)`). I restored the WAL-only condition. This is
the pre-fix code.

The first hunk (the assert in backupOnePage replacing the in-function READONLY
check) is already in its post-fix form in 3.54.1, so the assert stays. With the
guard removed, it is what trips; in a non-debug build the result is the
original segfault or corruption.

## Oracle failures
Backup of a smaller-page-size db into a non-empty in-memory db no longer
returns SQLITE_READONLY. In the debug testfixture, the assertion
`nSrcPgsz==nDestPgsz || sqlite3PagerIsMemdb(pDestPager)==0` in backupOnePage
fails, aborting test/backup.test at backup-4.5.2. backup-12.1, the case the fix
added, would hit the same path.
