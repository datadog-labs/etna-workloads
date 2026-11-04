Reproducer: grouped aggregates with a FILTER whose predicate evaluates to NULL (`b < 1` where b is NULL).
Statements are copied from the SLT tests added by the fix (`count` and `corr`).
Clean build excludes NULL-filter rows: `COUNT(a)` = 0 and `corr` = NULL.
Buggy build treats NULL filter results as true: `COUNT(a)` = 1 and `corr` = 1.0.
