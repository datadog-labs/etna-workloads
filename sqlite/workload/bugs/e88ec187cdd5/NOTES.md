repro.sh creates x/test.db (WAL, table t1), plus a relative symlink y/test.db -> ../x/test.db, then opens the database through y/test.db from the cwd.

Clean: the relative link is resolved against the link's directory (y/), so it opens x/test.db and prints `hello|world`.
Buggy: the relative link is resolved against the cwd, so it opens a different, empty file and fails with `no such table: t1`.
