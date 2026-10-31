# gh-142556 reintroduced

Hunk: Modules/_asynciomodule.c `TaskObj_dealloc`. The fix replaced
`_PyObject_ResurrectStart` / `unregister_task` / `PyObject_CallFinalizer` /
`_PyObject_ResurrectEnd` with `PyObject_CallFinalizerFromDealloc` followed by
`unregister_task`. I restored the old ordering: the task is unregistered
*before* finalization, so a task re-registered during finalization (via
`call_exception_handler`) stays in the registry after it is resurrected or freed.
The v3.15.2 `PyObject_GC_UnTrack` before unregistering is kept, moved after the
resurrection check; it was the later addition for a different issue.

Oracle: `test_register_task_resurrection` (CIntrospectionTests) hits the stale
registration and crashes. Many other C task tests fail because the run crashes
(incomplete run).
