Reproducer (repro.sql): creates a view containing a window function (`sum(a) OVER (ORDER BY b)`) and selects from it.
The view's select gets duplicated with EXPRDUP_REDUCE; the injection drops EP_FullSize on window-function Exprs, so they get reduced.
Clean shell prints 1 and 4. Buggy shell aborts (exit -6) on assertion in sqlite3ExprDeleteNN (`!ExprUseYWin(p) || p->y.pWin!=0 ...`).
