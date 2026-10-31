# Rationale

Fix hunk (Objects/capsule.c, `capsule_traverse`): replaced the
`assert(traverse_func != NULL)` + unconditional call with a NULL check that returns 0.

In v3.15.2 the function has the same logic (with `_PyCapsule_CAST(self)`), so I
reverted it to the pre-fix form: assert that `traverse_func` is non-NULL and call it
unconditionally. `gc.get_referents()` on an untracked capsule (e.g. `_datetime.datetime_CAPI`)
now calls a NULL function pointer (crash in release builds, assert in debug).

Oracle: `test_get_referents_on_capsule` fails by crashing the interpreter (SIGSEGV),
which also aborts the rest of the test_gc run (hence the other cases reported as failing).
