# Rationale
The hash key code moved from plpgsql (pl_comp.c / plpgsql.h) to the shared function cache in PG18, so the fix was re-expressed there.

## Changed hunk
- File: src/backend/utils/cache/funccache.c, function `cfunc_hashkey_init` (the hash-key computation).
- Traces to the fix_impl.patch hunk in `compute_function_hashkey` (pl_comp.c) that added `hashkey->isEventTrigger = CALLED_AS_EVENT_TRIGGER(fcinfo);`.
- I removed that assignment. The `isEventTrigger` field stays in the struct in funccache.h, but it is now always zero.
- Result: an event trigger call and a plain-function call of the same function OID produce the same hash key. They share one compiled function, so the wrong variant gets used. That is the bug the fix removed.

## Failing oracle cases
- src/test/regress||event_trigger
