`repro.sql` creates a table whose column types are quoted identifiers (`"INTEGER"`, `[TEXT]`, `` `INT` ``) with AUTOINCREMENT, then runs `PRAGMA table_info`.

- Clean shell: the table is created and `table_info` shows the unquoted types INTEGER, TEXT and INT.
- Buggy shell: the quotes are no longer stripped from the type names, so CREATE TABLE fails with "AUTOINCREMENT is only allowed on an INTEGER PRIMARY KEY" (exit status 1).
