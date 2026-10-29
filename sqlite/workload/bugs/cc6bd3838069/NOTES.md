With count_changes on, `INSERT`/`DELETE` on a table with triggers that themselves insert/delete should report only the outer statement's row count.

`repro.sql` enables `PRAGMA count_changes`, creates a table with BEFORE INSERT and BEFORE DELETE triggers that modify a mirror table, then runs one INSERT and one DELETE.

- Clean shell: prints `1` for the INSERT and `1` for the DELETE (2 lines).
- Buggy shell: the trigger bodies also emit their own count rows, so it prints `1 1 1 1` (4 lines).
