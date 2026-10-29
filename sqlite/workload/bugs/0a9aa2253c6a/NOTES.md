repro.sql: creates a table whose column default is the expression datetime('now'), inserts a row using the default, and selects length(y).
Clean shell prints 1|19 (exit 0). Buggy shell aborts with an assertion failure in sqlite3WalkExprNN (pList/pRight), because the duplicated token-only expression lost EP_Leaf.
