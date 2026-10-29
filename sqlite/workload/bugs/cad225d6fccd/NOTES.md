repro.sql creates a table with a generated column whose expression is RAISE(IGNORE), then selects from it.
Clean shell: reports "RAISE() may only be used within a trigger-program" and exits 1.
Buggy shell: the generated-column code overwrites Expr.affExpr (which RAISE uses for its action), so an assertion in sqlite3ExprCodeTarget fails and the shell aborts (exit -6).
