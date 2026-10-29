`repro.sh` creates a WAL database, reopens it, and queries the persist-WAL flag with
`.filectrl persist_wal` (no argument, which passes -1 to SQLITE_FCNTL_PERSIST_WAL), then sets it to 1 and queries again.

Clean shell prints 0 then 1 for the queries. Buggy shell leaves the -1 query argument unchanged and prints -1 both times.
