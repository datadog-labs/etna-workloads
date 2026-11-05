# Rationale
src/backend/utils/adt/jsonfuncs.c, jsonb_concat(): reverted the fastpath to the pre-fix "if either operand has zero root count, return the other" (the single hunk of fix_impl.patch). An empty operand of a different kind or a scalar now returns the other operand unchanged instead of concatenating.
Failing oracle case: src/test/regress||jsonb
