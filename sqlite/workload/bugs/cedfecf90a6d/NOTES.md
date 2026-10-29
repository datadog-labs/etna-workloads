Creates a table named `sqliteDemo` (starts with "sqlite" but not "sqlite_") and runs ANALYZE.
Clean shell: sqlite_stat1 contains a row for sqliteDemo. Buggy shell: the LIKE pattern
`sqlite_%` treats `_` as a wildcard, so the table is skipped and the query returns no rows.
