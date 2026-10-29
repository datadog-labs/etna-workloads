REPLACE INTO a table with a CHECK constraint that the new row violates.
Clean: fails with "CHECK constraint failed: x<5" (REPLACE falls back to ABORT), exit status 1.
Buggy: the row is silently skipped like OR IGNORE; no error, exit status 0.
