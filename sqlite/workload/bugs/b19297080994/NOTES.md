repro.sql: main.c1 holds a row, while attached aux has p1 and an empty aux.c1 that references p1 with ON DELETE RESTRICT. Deleting from aux.p1 should succeed.
Clean: the delete succeeds (count 0). Buggy: the RESTRICT trigger scans main.c1 (wrong schema), so it fails with "FOREIGN KEY constraint failed" (count 1, exit 1).
