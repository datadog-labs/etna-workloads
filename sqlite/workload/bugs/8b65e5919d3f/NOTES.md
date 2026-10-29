repro.sql creates a table with `CHECK(1 COLLATE BINARY BETWEEN 1 AND 1)` and inserts a row (check-11.0/11.1 and cffault-1.0).

With the bug, the BETWEEN code generator makes a shallow copy of the left operand and turns it into a TK_REGISTER node, and CHECK constraints are coded from the original, immutable expression.
- Clean shell: both inserts succeed and the SELECT prints both rows.
- Buggy shell: it aborts with `sqlite3ExprIfTrue: Assertion '!ExprHasVVAProperty(pExpr, EP_Immutable)' failed` (exit status -6).
