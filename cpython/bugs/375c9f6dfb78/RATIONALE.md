# Rationale

Fix hunk: Lib/warnings.py added `import inspect` and, in the `callable(arg)`
branch of `deprecated.__call__`, marked the wrapper with
`inspect.markcoroutinefunction` when `arg` is a coroutine function.

In v3.15.2 that code lives in Lib/_py_warnings.py. I removed the `import inspect`
and the `if inspect.iscoroutinefunction(arg): wrapper = inspect.markcoroutinefunction(wrapper)`
lines, restoring the pre-fix wrapper.

Oracle: `test_inspect` (Python and C warnings variants) fails, since
`inspect.iscoroutinefunction` returns False for a deprecated async function or method.
