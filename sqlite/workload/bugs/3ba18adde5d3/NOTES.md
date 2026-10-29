Reproducer: `SELECT cast('-1e999' AS real);` (repro.sql).
Clean shell prints -Inf; buggy shell prints Inf (sign lost on overflow in sqlite3AtoF).
