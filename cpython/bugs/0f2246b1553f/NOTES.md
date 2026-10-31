repro.py calls repr() on an uninitialized list (`_testlimitedcapi.list_new(3)`), whose items are NULL.
Clean: prints `[<NULL>, <NULL>, <NULL>]`. Buggy: segfaults (exit -11), because the list repr no longer tolerates NULL items and PyUnicodeWriter_WriteRepr no longer handles NULL.
