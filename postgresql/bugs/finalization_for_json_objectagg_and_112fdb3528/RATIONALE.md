# Rationale

File: src/backend/utils/adt/json.c (fix.patch hunks all in this file)

1. Re-added `json_unique_builder_clean()` (hunk 1 of fix_impl.patch, reversed).
2. `json_object_agg_finalfn()`: re-added call `json_unique_builder_clean(&state->unique_check)` (hunk 2). The final function now modifies the aggregate state (resets skipped_keys), which finalfns must not do, e.g. when the aggregate is finalized and then continues (window/moving use).
3. `json_build_object_worker()`: re-added `if (unique_keys) json_unique_builder_clean(&unique_check);` (hunk 3).

Failing oracle case: src/test/regress||sqljson (see oracle output).

## Update
In current code, resetting `skipped_keys` alone is harmless (it only sets len=0), so the first attempt passed. The original cleanup freed state; I therefore made `json_unique_builder_clean()` also `hash_destroy` the duplicate-key hash and NULL it. Called from `json_object_agg_finalfn()`, this destroys aggregate state during finalization, so the next transition call in a window frame (e.g. `JSON_OBJECTAGG(... WITH UNIQUE KEYS) OVER (ORDER BY k)`) uses a freed/NULL hash and crashes.

Oracle result: src/test/regress||sqljson FAILS (confirmed).
