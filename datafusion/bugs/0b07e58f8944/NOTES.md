Reproducer: a sliding-window `percentile_cont(DISTINCT x, 0.5)` over rows (5, 5, 9) with frame `ROWS BETWEEN 1 PRECEDING AND CURRENT ROW`.

On the third row the frame is {5, 9}. The buggy build's retract removes the value `5` outright, even though another `5` is still in the frame. Row 3 therefore returns 9.0 on buggy and 7.0 on clean.
