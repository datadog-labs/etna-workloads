repro.sql runs `SELECT * EXCEPT/EXCLUDE(all columns)` on a 4-column table (plain, with LIMIT, with WHERE).
Clean build: each fails at planning with "SELECT list is empty after resolving * expressions, the wildcard expanded to zero columns".
Buggy build: the queries succeed and print empty zero-column tables (`++`).
