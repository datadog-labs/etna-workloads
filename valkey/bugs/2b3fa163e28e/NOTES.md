Reproducer: creates two zsets with infinite scores, then runs ZINTER ... WEIGHTS 0 1 / 1 0 (both argument orders) with AGGREGATE sum/min/max.
Clean: a NaN weighted score (0*inf) counts as 0 for every input, so results are order-independent (e.g. sum: x=-inf, y=5, z=-5, w=7).
Buggy: for non-first inputs NaN is not zeroed, so the reply depends on input order (NaN-derived scores differ/members lose or gain values).
