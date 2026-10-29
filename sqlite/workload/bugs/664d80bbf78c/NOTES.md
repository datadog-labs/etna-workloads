`repro.sql` queries the dbstat virtual table with `WHERE name = NULL`.
The injected bug marks the `name` constraint as omitted, so SQLite does not re-check it. dbstat treats a NULL name as "no filter".
The clean shell returns count 0. The buggy shell returns 2, which is every page of the database.
