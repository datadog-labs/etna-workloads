Reproducer: enables `datafusion.optimizer.filter_null_join_keys` and runs `NOT IN` against a subquery containing a NULL.
Clean build returns 0 rows (null-aware anti join semantics). Buggy build's FilterNullJoinKeys filters the NULL out of the
subquery side of the null-aware join, so it wrongly returns rows 1, 3, 4.
