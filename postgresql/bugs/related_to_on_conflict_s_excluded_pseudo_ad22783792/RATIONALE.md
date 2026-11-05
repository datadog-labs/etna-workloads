# Rationale

Changed: `src/src/backend/parser/parse_relation.c`, `scanRTEForColumn()`.
Traces to the fix.patch hunk in parse_relation.c. The fix made system-column lookup skip RTEs whose relkind is RELKIND_COMPOSITE_TYPE, which is how the EXCLUDED pseudo-relation is marked. I reverted the condition to `rte->rtekind == RTE_RELATION`. EXCLUDED then resolves system columns such as `excluded.ctid` as if it were a real table, so a reference that should be rejected is accepted.

The analyze.c and setrefs.c parts of the fix have since been refactored (`BuildOnConflictExcludedTargetlist`) or are comment-only, so I did not touch them.

Failing oracle case: src/test/regress||insert_conflict
(`rules` still passes.)
