# Rationale

The fix's function `plpgsql_resolve_polymorphic_argtypes` in pl_comp.c has since moved to
`cfunc_resolve_polymorphic_argtypes` in src/backend/utils/cache/funccache.c.

## Hunk: funccache.c, cfunc_resolve_polymorphic_argtypes
Traces to the fix_impl.patch hunk adding the "treat RECORD inputs (but not outputs) as polymorphic"
loop (and the `inargno` variable). I removed that loop, so RECORD/RECORD[] input args are no longer
replaced by the actual composite type of the call argument. As a result, plpgsql functions with RECORD
arguments share one cache entry and cannot handle different named composite types correctly.
(The comment-only hunks were not changed.)

## Failing oracle cases
src/pl/plpgsql/src||plpgsql_record (expected; see oracle run)
