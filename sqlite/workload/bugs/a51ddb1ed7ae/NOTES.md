repro.sql: a window function aliased `z` is used inside a non-top-level ORDER BY
expression (`y IS z`, `z + 0.0`). resolveAlias() copies the window expression
but (with the bug) doesn't reset pWin->pOwner.

clean: prints the correctly ordered averages, exit 0.
buggy: assertion failure `pWin->pOwner==pExpr` in selectWindowRewriteExprCb, exit 134.
