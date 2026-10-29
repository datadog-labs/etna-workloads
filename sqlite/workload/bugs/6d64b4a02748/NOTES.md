Reproducer (repro.sql) is the test case window1-71.0 from the fix: a query with a
window function inside a compound subquery in a row-value comparison, where the
window rewrite fails with an error.

Clean shell: `Parse error near line 2: 2 columns assigned 1 values`, exit 1.
Buggy shell: assertion failure in sqlite3TableColumnAffinity (the temp table from
the window rewrite is freed too early, leaving dangling references), abort, exit -6.
