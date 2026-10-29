`repro.sql` creates an ordinary table and selects from it using table-valued-function syntax with empty args: `SELECT * FROM t1();`.

Clean shell: `Parse error near line 2: 't1' is not a function` (exit 1).
Buggy shell: the injection skips marking the FROM item as a table function when the arg list is empty, so the query is accepted silently (exit 0).
