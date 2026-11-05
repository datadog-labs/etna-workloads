# Rationale

File: src/backend/backup/basebackup_server.c, function bbsink_server_new().
Traces to the single fix.patch hunk (plus the `access/xact.h` include hunk): removed
`StartTransactionCommand()` / `CommitTransactionCommand()` around the
`has_privs_of_role(GetUserId(), ROLE_PG_WRITE_SERVER_FILES)` check (and the now-unused include).
Without a transaction, the role-membership check (catalog lookups) runs outside a transaction
in the walsender, crashing the server when the 'server' backup target is used.

Failing oracle cases: 40/200, all in src/bin/pg_basebackup|t/010_pg_basebackup.pl
(e.g. "tblspc directory copied", "two files created with --gzip (base.tar.gz and pg_wal.tar.gz)",
"two files created with --compress=NUM ...", "... --compress=gzip:NUM ...") — the test aborts when the server backup crashes.
