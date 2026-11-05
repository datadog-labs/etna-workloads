# Rationale
File: src/backend/executor/execIndexing.c, ExecInsertIndexTuples().
Traces to the last fix_impl.patch hunk (`if (noDupErr)` -> `if (applyNoDupErr)`). Reverted to `if (noDupErr)`, so when a unique-check conflict is found in a non-arbiter exclusion constraint during ON CONFLICT, the violation is treated as OK (speculative) instead of raising an error; the conflict is missed.
Failing oracle case: src/test/regress||insert_conflict (expected).
