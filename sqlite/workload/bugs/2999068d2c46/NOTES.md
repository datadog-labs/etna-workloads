`repro.sql` drops the fts3 module with `.unmodule fts3` (the CLI equivalent of `sqlite3_drop_modules(db, "fts4")`), then creates an fts4 table.

- Clean: the table is created, and the `sqlite_master` listing shows t1 and its shadow tables.
- Buggy: dropping fts3 runs its destructor, which frees the tokenizer hash that fts4 still points to. The CREATE fails with "unknown tokenizer: simple", and the exit status is 1.
