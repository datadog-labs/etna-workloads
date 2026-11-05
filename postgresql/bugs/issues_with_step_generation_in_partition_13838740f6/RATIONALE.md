# Rationale

## Changed hunk
- File: `src/backend/partitioning/partprune.c`, function `gen_partprune_steps_internal`, case `PARTCLAUSE_MATCH_NULLNESS`.
- Traces to the first hunk of fix.patch. The fix added `|| keyclauses[i] != NIL` so that an `IS NULL` clause on a key that already has strict clauses is detected as contradictory.
- I reverted this to check only `bms_is_member(i, notnullkeys)`. A qual such as `a = 1 AND a IS NULL` is then no longer marked contradictory, so pruning steps are generated that can return partitions the qual can never match.

## Not reverted
The other fix hunks (`gen_prune_steps_from_opexps` prefix handling, `get_steps_using_prefix`, and the recursion cleanups) no longer match the current code, which has evolved. I left them alone.

## Oracle cases expected to fail
- `src/test/regress||partition_prune`

This list is what I expect, not a result. The oracle run had not finished when I wrote this file, so I have not confirmed the failure.
