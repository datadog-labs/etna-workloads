`repro.sql` creates a table whose column has `DEFAULT (?)`, a bound parameter in the DEFAULT clause.
Clean shell: "default value of column [b] is not constant" error (exit 1).
Buggy shell: the parameter is accepted (the TK_VARIABLE check is removed), so the CREATE succeeds silently (exit 0).
