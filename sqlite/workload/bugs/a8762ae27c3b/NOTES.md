Renames an INTEGER PRIMARY KEY column that is referenced in a CHECK constraint.
Clean shell succeeds and prints the updated schema (CHECK uses a1); the buggy shell fails
the ALTER TABLE RENAME COLUMN (error / assertion), so the output differs.
