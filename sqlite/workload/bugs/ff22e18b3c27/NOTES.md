Reproducer (repro.sql): create a table with a COLLATE column, then ALTER TABLE ADD COLUMN.
The buggy build skips duplicating zCnName for columns with COLFLAG_HASCOLL, so the
temporary table shares/frees the name string. Clean: no output, exit 0. Buggy: assertion
failure in sqlite3DeleteColumnNames (abort, exit -6).
