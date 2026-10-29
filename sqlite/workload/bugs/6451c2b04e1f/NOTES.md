Reproducer (`repro.sh`): holds a BEGIN EXCLUSIVE lock on t.db, then ATTACHes the same
file with `mode=ro&nolock=1` and selects from it.

Clean: nolock is honored for read-only opens, no locks taken, SELECT returns `1`.
Buggy: the nolock URI parameter is ignored when readonly, so a lock is attempted:
"database is locked" on ATTACH, then "no such table: x.t1", exit status 1.
