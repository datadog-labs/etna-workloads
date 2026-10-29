Table t1 has rows (1,2), ('null!',NULL), (3,4). ALTER TABLE ADD COLUMN with a
CHECK that an existing row violates should fail with "CHECK constraint failed",
and a generated NOT NULL column that evaluates to NULL should fail with
"NOT NULL constraint failed". The buggy shell mishandles the quick_check
result selection in the post-ALTER verification, so the errors differ
(wrong/missing error) from the clean shell.
