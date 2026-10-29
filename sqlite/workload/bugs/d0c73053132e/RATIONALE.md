# Rationale

Fix: `sqlite3ExprListFlags()` gained a NULL check on `pList->a[i].pExpr`
(NULL exprs appear in an ExprList after a syntax error, e.g. `T(#0)` in a
corrupt schema).

In 3.54.1 that check was replaced by `assert( pExpr!=0 )`, and the case is
also covered by an early `if( pParse->nErr ) return;` in
`sqlite3ExprSetHeightAndFlags()` (the only caller path that reaches it).

Changes in src/expr.c:
1. `sqlite3ExprListFlags`: removed the `assert( pExpr!=0 )` and dereference
   the entry directly (`m |= pList->a[i].pExpr->flags;`), i.e. the pre-fix
   unchecked dereference.
2. `sqlite3ExprSetHeightAndFlags` (both the height-enabled and disabled
   variants): removed the `if( pParse->nErr ) return;` guard, the second
   path that keeps erroneous (NULL-containing) lists away from
   `sqlite3ExprListFlags`. Same defect: NULL list entries reach the flag scan.

Result: `./check.sh` on test/misc1.test crashes (NULL deref) at misc1-21.1,
so 12 oracle cases fail (misc1-21.1 .. misc1-28.0, incomplete run), including
misc1-23.1 which never completes. Before the change, 0 failed.
