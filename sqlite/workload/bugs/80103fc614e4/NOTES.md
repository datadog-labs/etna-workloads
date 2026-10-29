`repro.sql` runs `ORDER BY 1 COLLATE """"""""` (collation named `"""`) on a table and in a compound SELECT.
The collation name is dequoted twice in the buggy build (the injection makes `sqlite3ExprAddCollateString` dequote).
Clean: "no such collation sequence: \"\"\"" errors, exit 1. Buggy: assertion failure in sqlite3Dequote (`z[i]`), abort (exit 134).
