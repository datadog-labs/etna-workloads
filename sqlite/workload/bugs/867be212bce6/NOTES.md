repro.sql creates a view containing a window function (sum(b) OVER (ORDER BY a)) and selects from it.
Clean shell prints 2, 6, 6 and exits 0. Buggy shell aborts with an assertion failure in
sqlite3ExprDeleteNN (`!ExprUseYWin(p) || p->y.pWin!=0 ...`), exit status 134. The injection drops
EP_FullSize on window-function Exprs, so reduced copies of them (made when the view is expanded) are mishandled.
