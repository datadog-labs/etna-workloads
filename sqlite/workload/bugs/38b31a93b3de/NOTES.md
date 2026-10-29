repro.sql: creates a table, adds columns with non-NULL defaults via ALTER TABLE ADD COLUMN,
records a DELETE of a pre-ALTER row with the shell's `.session` (session extension, which uses
the preupdate hook), and dumps the changeset as hex.
Clean: old.* values for b/c are the defaults (1234, 'abcdef': 01..04D2, 03 06 616263646566).
Buggy: sqlite3_preupdate_old() returns NULL for them (05 05 bytes), so the changeset is wrong.
(Writes a scratch file cs.bin in the cwd.)
