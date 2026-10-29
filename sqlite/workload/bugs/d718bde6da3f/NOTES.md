Creates a STRICT table with one row, then ALTER TABLE ADD COLUMN b TEXT DEFAULT x'313233' (a BLOB default in a TEXT column).
Clean shell: the ALTER fails with "type mismatch on DEFAULT". Buggy shell: the ALTER succeeds, leaving the existing row with an invalid BLOB in a TEXT column; the following INSERT then fails with "cannot store BLOB value in TEXT column t1.b".
