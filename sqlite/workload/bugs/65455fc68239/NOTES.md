repro.sql creates a table named `sqlite1234` and renames it to `User`. The buggy build filters schema rows with
`LIKE 'sqlite_%'`, where `_` is a wildcard, so the `sqlite1234` row is skipped. The rename then fails with
"error in table User after rename:" (exit status 1), and sqlite_master keeps the old name.
The clean shell renames the table and prints `User|CREATE TABLE "User" (id integer)`.
