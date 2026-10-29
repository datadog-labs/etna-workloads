repro.sh: builds an AUTOINCREMENT table, then (with defensive off, writable_schema on)
renames sqlite_sequence to x_sequence in sqlite_master (autoinc-12.2). A second
connection then does an INSERT into the autoincrement table.

Clean: "database disk image is malformed (11)", exit 1.
Buggy: no sqlite_sequence check, so the shell segfaults (exit 139).
