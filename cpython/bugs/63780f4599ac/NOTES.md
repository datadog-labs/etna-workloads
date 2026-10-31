# Reproducer notes

`repro.py` is a translation of the test added by the fix,
`test_remove_done_callbacks_list_clear` (and the related
`test_remove_done_callbacks_list_mutation`), exercising the C
implementation of `asyncio.Future.remove_done_callback`
(`_asynciomodule.c`'s `_asyncio_Future_remove_done_callback`).

It creates a `_CFuture`, attaches 64 done-callbacks, then calls
`remove_done_callback()` with an "evil" argument whose `__eq__` is invoked
by the C code while it iterates `fut_callbacks` (via
`PyObject_RichCompareBool`). That `__eq__` itself calls
`remove_done_callback()` again, which empties and clears `fut_callbacks`
(`Py_CLEAR(self->fut_callbacks)`) out from under the outer, still-running
loop.

Without the fix, the outer loop keeps using the stale `PyList_GET_SIZE`
bound and item pointers from the now-freed/`NULL` list, so it reads
freed/`NULL` memory.

- On `python-clean` (fix present): the outer loop re-checks
  `self->fut_callbacks != NULL` each iteration, stops safely, and
  `remove_done_callback()` returns `63`. Exit status 0.
- On `python-buggy` (fix reverted): the stale iteration dereferences the
  cleared list, producing a crash (SIGSEGV, exit status -11 as seen with
  `./check.sh`) instead of returning a value.
