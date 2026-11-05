# Rationale

Fix removed: pg_dump/pg_restore plain-text output wrapped in psql `\restrict KEY` / `\unrestrict KEY`.

Changed file: src/bin/pg_dump/pg_backup_archiver.c (3 hunks, tracing to the pg_backup_archiver.c hunks of fix.patch)
- `RestoreArchive`: removed emission of `\restrict` after the header comment (fix hunk @@ -459).
- `RestoreArchive`: removed emission of `\unrestrict` at the end of the script (fix hunk @@ -799).
- `_reconnectToDB`: removed the `\unrestrict` / `\restrict` wrapping around `\connect` and restored the original `"%s\n"` format (fix hunk @@ -3437).

Effect: plain-text dumps no longer enter restricted mode, so psql meta-commands injected by a malicious source execute on restore, and tests expecting the restrict lines fail.

Failing oracle cases: the oracle reported 10067 of 13974 failing, mainly pg_dump/pg_restore/pg_upgrade and dump-comparison TAP cases (e.g. src/bin/pg_dump t/002_pg_dump.pl). I did not capture the full list of IDs; it is in logs/oracle.log.
