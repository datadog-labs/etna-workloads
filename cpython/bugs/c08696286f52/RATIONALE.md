# Rationale

## Modules/_asynciomodule.c: `_asyncio_Task_get_coro_impl`
Reverses the only implementation hunk of the fix (gh-122332). The fix added a
`self->task_coro` NULL check returning `None`. I removed it, so the function
is again `return Py_NewRef(self->task_coro);`. In v3.15.2 the function has
the same shape (now under `@critical_section`), so the revert is direct.
`task_coro` is NULL when an eager task completes during its first step
(`clear_task_coro`). I left the `_coro` getter's NULL check alone because the
fix did not touch it.

## Oracle failures
`test_issue122332` (CEagerTaskFactoryLoopTests) fails: `task.get_coro()` on a
finished eager task calls `Py_NewRef(NULL)`, which crashes the interpreter.
The run is incomplete because of that crash, so the other cases in
`test_eager_task_factory.py` after it are reported as failing too.
