# Rationale

Fix hunk reversed: the `Modules/_datetimemodule.c` hunk in `datetime_strptime`
(the `static PyObject *module` cache vs. `PyImport_Import(&_Py_ID(_strptime))`).
In v3.15.2 the code lives in `datetime_datetime_strptime_impl`. I restored the
function-local `static PyObject *module`, lazily filled by
`PyImport_ImportModule("_strptime")` and never released, so it survives
interpreter finalization and re-init as a dangling reference.

The `_Py_ID(_strptime)` additions and the globals-to-fix.tsv edit are
generated or tooling files, so I left them alone. `_Py_ID(_strptime)` is still
used by `date.strptime` and `time.strptime`, which I did not change.

Oracle failure: `test.test_embed.EmbeddingTests.test_datetime_reset_strptime`.
On the second init loop, the cached module is stale and the call fails with
`TypeError: 'NoneType' object is not callable`. The test expects it to print
`20000101` every loop.
