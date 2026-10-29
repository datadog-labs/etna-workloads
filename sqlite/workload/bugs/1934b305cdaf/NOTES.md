Reproducer (repro.sql): adds a REAL column with default 9223372036854775807 via ALTER TABLE, indexes it, then queries/inserts.

Clean: `WHERE c = 9.2233720368547758e+18` returns ids 1,2,3, and the insert into the UNIQUE-indexed table fails with "UNIQUE constraint failed: u.c".
Buggy: the index stores the large default as an integer for existing rows, so the query returns only id 3 and the duplicate insert succeeds (exit 0).
