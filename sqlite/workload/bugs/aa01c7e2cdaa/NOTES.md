CHECK constraint violations should honor the statement's conflict clause (OR IGNORE etc.).
repro.sql runs UPDATE/INSERT OR IGNORE that violate a CHECK. Clean: silently skipped, table unchanged.
Buggy: the statements abort with "CHECK constraint failed" (the script continues in batch mode, so the errors show up in output).
