`{}.keys() & 1` and `{}.items() & 1` should raise TypeError. With the bug,
`_PyDictView_Intersect` doesn't check the NULL result of `PyObject_GetIter`,
so it crashes or misbehaves (leaking the error/segfault/assert) instead of
cleanly raising TypeError. The reproducer prints "TypeError" twice on the clean
interpreter; the buggy one differs.
