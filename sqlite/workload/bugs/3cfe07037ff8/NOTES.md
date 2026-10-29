Reproducer: `repro.sh`. The shell can't hold a read statement open across statements, so it uses two shared-cache connections (`.connection 1`) to the same file.

Connection 0 opens a read transaction (`BEGIN; SELECT * FROM sqlite_master`), so the shared pager keeps its SHARED lock. Connection 1 then runs `journal_mode=truncate; BEGIN; UPDATE t4 ... WHERE 0; COMMIT;`, a commit that modifies no pages. It then runs `PRAGMA lock_status`.

Clean shows `main|shared`. Buggy shows `main|exclusive`, because the commit no longer drops the write lock. This is the same condition as lock-7.3.
