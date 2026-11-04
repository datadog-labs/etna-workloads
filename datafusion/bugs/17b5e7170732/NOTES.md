repro.sql creates a table from two struct VALUES rows whose field types need coercion (`{r:'a', c:1}` and `{r:'b', c:2.3}`), then selects it and prints its type.

- Clean: the table is created, and the struct field names `r` and `c` are preserved (`{r: a, c: 1.0}`).
- Buggy: coercion renames the fields to `c0` and `c1`, so CREATE TABLE fails with "Unsupported CAST from Struct(r, c) to Struct(c0, c1)". The later selects then fail with "table not found".
