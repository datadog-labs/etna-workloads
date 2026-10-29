`repro.sql` creates `abc(a, b NOT NULL AS (a+1))`, runs `ALTER TABLE abc ALTER b DROP NOT NULL`, and prints the stored schema SQL.

- Clean shell: `CREATE TABLE abc(a, b AS (a+1))`.
- Buggy shell: `CREATE TABLE abc(a, b)`. The generated-column clause is lost, because the constraint scanner no longer stops at `AS` or `GENERATED`.

This is the same case as altercons2-9.1.
