# gh-109786: pairwise.__next__ re-entrancy

All changes are in `pairwise_next` in `Modules/itertoolsmodule.c`, reversing the fix's single hunk:

- First-item fetch: restored `po->old = old = next(it)`. This drops the `Py_XSETREF` and the re-check of `po->it` after the call. A re-entrant call can therefore overwrite or clear `po->old`/`po->it` while this frame still uses the stale `it`/`old`.
- Removed `Py_INCREF(old)` and the matching `Py_DECREF(old)` calls (on the error path and at the end). `old` is no longer held alive across the `tp_iternext` call, so re-entry can free it (use-after-free).
- Final store restored to `Py_SETREF(po->old, new)` from `Py_XSETREF`. If `po->old` was cleared by re-entry, the old code mishandles it.

The tuple-reuse and `_PyTuple_FromPair` code was added after the fix and is left as it is.

## Oracle result
`test_pairwise_reenter2` fails and the test run crashes. The crash stops the later cases from running, so many other cases in the file are reported as failing too.
