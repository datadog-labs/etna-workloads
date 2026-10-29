repro.sql runs ALTER TABLE ... ALTER col SET NOT NULL / DROP NOT NULL against a view and sqlite_schema.
Clean: errors "cannot edit constraints of view" / "table sqlite_master may not be altered" (exit 1).
Buggy: the view/system-table checks are gone, so it hits an assertion failure in sqlite3ColumnIndex (abort).
