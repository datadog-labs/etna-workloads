repro.sql creates a view whose CTE references a nonexistent column (sts.aa), then selects from it with a long query.
The error occurs inside the view text, so sqlite3_error_offset() should be -1.
Clean shell: prints only "Parse error near line 5: no such column: sts.aa".
Buggy shell: also prints a bogus "error here ---^" marker, pointing into the outer query using the view's offset.
