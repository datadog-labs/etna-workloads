# gh-140373 reintroduced

Fix hunk reversed: `Objects/genobject.c` `gen_close()`. The fix made the
"skip throwing GeneratorExit" fast path conditional on
`_PyEval_NoToolsForUnwind(...)`. In v3.15.2 the helper takes `(tstate, frame)`
and checks local events. I removed the `no_unwind_tools` variable and the
`&& no_unwind_tools` condition, so closing a suspended generator at depth 1
always takes the fast path and never emits PY_UNWIND. The helper in ceval.c
and its declaration are left as they were (the fix's hunks there only add them).

Oracle failures: test_sys_setprofile (generator close no longer produces the
extra call/return events), and test_monitoring.test_gen_unwind (no unwind event
for GeneratorExit in gen).
