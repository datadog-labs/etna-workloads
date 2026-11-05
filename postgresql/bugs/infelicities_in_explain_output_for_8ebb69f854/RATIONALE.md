Changed file: src/src/backend/commands/explain.c, function ExplainNode (both hunks trace to fix_impl.patch's explain.c changes).

1. Removed the `if (partialmode) ExplainPropertyText("Partial Mode", ...)` output in the non-text branch (fix hunk "Partial Mode"). Aggregate nodes in JSON/XML/YAML EXPLAIN again lack the "Partial Mode" property.
2. Reverted "Parallel Aware" to `if (plan->parallel_aware) ExplainPropertyText(..., "true")` instead of always emitting a boolean (fix hunk replacing it with ExplainPropertyBool). Structured formats again omit "Parallel Aware": false.

Failing oracle case: src/test/regress||insert_conflict
