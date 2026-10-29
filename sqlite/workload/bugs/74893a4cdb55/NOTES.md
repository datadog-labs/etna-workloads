Runs `select''like''like''like#0;` (a syntax error after nested LIKE parsing).
Clean: prints the syntax error near "#0", exit 1. Buggy: assertion failure in sqlite3ExprListFlags (pExpr!=0), abort, because sqlite3ExprSetHeightAndFlags lacks the pParse->nErr early return.
