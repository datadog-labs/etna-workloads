Calls `time.gmtime(0).__replace__(tm_year=[])` and checks `gc.is_tracked` on the result.
Clean prints `True`; buggy prints `False` because `structseq.__replace__` omits `_PyObject_GC_TRACK`.
