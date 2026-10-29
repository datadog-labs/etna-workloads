The preupdate hook is only reachable from the shell through the session extension.
`repro.sql` creates two tables with a `REAL PRIMARY KEY`. The source table's row is
rewritten by an UPDATE, so its record stores 7.0 compactly as an integer. The script
deletes the row from the attached table, then re-inserts it with `INSERT ... SELECT`.
That copies the raw record, and `sqlite3_preupdate_new()` sees a MEM_Int in the PK column.

Clean: the new PK is reported as FLOAT and matches the earlier DELETE's old PK (FLOAT).
The session merges them into one UPDATE change (op 0x17).
Buggy: the new PK is reported as INTEGER, so it doesn't match the DELETE.
The changeset has a separate INSERT (0x12) and UPDATE (0x17) instead of one UPDATE.
