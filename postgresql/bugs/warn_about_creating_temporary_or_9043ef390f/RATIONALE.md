# Rationale

## src/backend/commands/indexcmds.c, DefineIndex()
Traces to the single hunk in fix_impl.patch (the `strcmp(accessMethodName, "hash") == 0 && RelationNeedsWAL(rel)` warning).
In REL_18_6 the warning had been removed altogether (hash indexes are WAL-logged now). The pre-fix behavior is an
unconditional "hash indexes are not WAL-logged" WARNING, even for temp/unlogged tables. I re-added it, without the
RelationNeedsWAL condition, right after the access method lookup. Creating any hash index, including
`CREATE INDEX ... USING hash` on an UNLOGGED table, now emits a spurious warning.

## Failing oracle cases
- src/test/regress||create_index
