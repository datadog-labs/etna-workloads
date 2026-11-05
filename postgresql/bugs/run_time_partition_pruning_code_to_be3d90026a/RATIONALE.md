# Rationale

File: src/backend/partitioning/partprune.c, function perform_pruning_base_step().

Traces to the fix.patch hunk that adds the `if (isnull) { return empty PruneStepResult; }` block
after the comparison value is obtained. Today partkey_datum_from_expr() already returns *isnull
(the signature and Const/Param hunks of the fix are in place), so I re-expressed the pre-fix
behavior in the caller. Before the fix, a NULL value meant the key could not be used for pruning.
Now a NULL-valued key is skipped (`if (isnull) continue;`) instead of yielding an empty result. The
step then prunes nothing, so `a = (select null::int)` no longer prunes all partitions, because
Append scans them instead of showing "never executed".

(A first attempt that only deleted the null check passed the test, because the NULL datum 0
matches no list bound by luck.)

Failing oracle case: src/test/regress||partition_prune
