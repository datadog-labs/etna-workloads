repro.sql is the fts5ak-4.0 SQL verbatim (no page-size dependence). The query hits SQLITE_SCHEMA
while another statement is running.
- clean: prints an empty line (NULL), exit 0.
- buggy: assertion `sqlite3BtreeCursorIsValid(pCur)` fails in sqlite3VdbeExec, exit 134 (abort).
