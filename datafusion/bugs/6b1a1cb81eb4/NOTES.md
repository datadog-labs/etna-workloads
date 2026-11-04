Reproducer: `median(DISTINCT x)` over a running window frame (ROWS UNBOUNDED PRECEDING..CURRENT ROW), from the aggregate.slt test added by the fix.

Clean: running distinct medians (10, 15, 20, 25, 30 ...). Buggy: `evaluate()` drains the accumulator state with `mem::take`, so each row returns only its own value (10, 20, 30, 40, 50 ...).
