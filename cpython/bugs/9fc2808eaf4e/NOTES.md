Calls `_interpreters.exec(id, 'a', shared=1)` with a non-dict `shared`.
Clean: raises TypeError ("argument 'shared' must be dict, not int").
Buggy: the clinic dict check is removed, so it hits `assert(PyDict_Check(nsupdates))` in `_PyXI_Enter` and aborts (exit -6).
