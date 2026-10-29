repro.sql: sets locking_mode=EXCLUSIVE, creates a table inside a transaction and rolls back, then queries sqlite_master and creates/rolls back a temp table.
Clean shell: no output besides "exclusive". Buggy shell: "database disk image is malformed (11)" errors and exit status 1, because the pager rollback no longer truncates cached pages beyond EOF.
