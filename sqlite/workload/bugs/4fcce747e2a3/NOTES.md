repro.sql: in a UTF-16 database, creates an fts5 table with pgsz=37, inserts numeric values, then runs integrity-check.
Clean shell: no output, exit 0. Buggy shell: "fts5: corruption found reading blob ..." and exit 1
(integrity check reads the index term with sqlite3_column_text, which converts to UTF-16, instead of the blob).
