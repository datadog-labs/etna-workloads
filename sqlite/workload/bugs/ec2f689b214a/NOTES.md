repro.sql runs the upfrom1-5.1 case: an UPDATE with a row-value assignment `(c,b)=(SELECT 3,4)` and a FROM clause containing a UNION ALL view.
Clean shell prints `4|3`. The buggy shell hits the injected assert in sqlite3ExprListDup (`pOldExpr->pLeft==pOldExpr->pRight`) and aborts.
