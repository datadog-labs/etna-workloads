# Rationale

Fix hunk (Python/perf_trampoline.c, `_PyPerfTrampoline_AfterFork_Child`): added an unconditional
`perf_trampoline_reset_state()` after `_PyPerfTrampoline_Fini()` and before `_PyPerfTrampoline_Init(1)`,
so a stale code watcher from the parent is cleared before Init registers a new one.

In v3.15.2 that call had become `perf_trampoline_clear_code_watcher()` (watcher only, keeping arenas).
I removed that call (and its comment), restoring the pre-fix behaviour: when `trampoline_refcount > 0`
after Fini, the old watcher stays registered and Init registers a second one, so two watchers
double-decrement `trampoline_refcount`.

Oracle failure: `test_trampoline_works_after_fork_with_many_code_objects` fails; the child aborts with
`Assertion 'extra_code_index != -1' failed` in `py_trampoline_evaluator` (signal 6). Other cases pass.
