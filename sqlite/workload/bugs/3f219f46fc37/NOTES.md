Sums a table containing only NULLs. Clean: `sum(x)` is NULL (`|0.0`). Buggy: sumFinalize ignores
the `cnt>0` check, so sum(x) returns 0 instead of NULL (`0|0.0`).
