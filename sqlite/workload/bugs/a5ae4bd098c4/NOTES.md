Reproducer: a table-valued function (json_each) on the left of a RIGHT JOIN whose argument references t0, a table to its right.
Clean shell: "Error: table-function argument references tables to its right".
Buggy shell: the error is not raised, so the query runs silently (exit 0, no output).
