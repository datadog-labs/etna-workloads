# Rationale

File: src/backend/partitioning/partprune.c, function match_clause_to_partition_key (final return).
Traces to the fix.patch hunk replacing `return PARTCLAUSE_UNSUPPORTED;` with `return boolmatchstatus;`.
Restoring the unconditional PARTCLAUSE_UNSUPPORTED means a boolean clause that merely fails to match the
current partition key (should be NOMATCH, so other keys are tried) stops matching against remaining
partition keys, so pruning with multiple boolean RANGE partition keys is lost/wrong.

Failing oracle case: src/test/regress||partition_prune
