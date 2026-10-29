# Rationale

Fix hunk reversed: src/resolve.c, the FILTER-with-non-aggregate check in
resolveExprStep (TK_FUNCTION). The fix moved it from the first `if/else if`
chain (where it preceded the `wrong_num_args` check) to after the
`no_such_func`/`wrong_num_args` branches, so wrong-argument-count errors win.

In 3.54.1 that check already sat after `wrong_num_args`. I moved it back
into the first chain, directly after the "misuse of ... function" branch, so it
again takes priority. The message text and the condition are unchanged. I
dropped the old `assert(!IsWindowFunc(pExpr))` because it is not present in
3.54.1 and would be false for this case.

Effect: `SELECT row_number(x) OVER () FROM t1` finds the function via the
-2 (any-arg-count) lookup, so `wrong_num_args=1` and `is_agg=0`, and the
window expression reports "FILTER may not be used with non-aggregate
row_number()" instead of "wrong number of arguments to function row_number()".

Oracle failure: window1-7.1.8 (wrong message). windowerr-3.3 only checks that
an error occurs, so it still passes.
