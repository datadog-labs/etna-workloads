# gh-135855 reintroduced

Changes (all in tree/):
- Modules/_interpretersmodule.c: `updates` clinic converter changed from `object(subclass_of='&PyDict_Type')` back to `object` (reverses the `OO!` / `&PyDict_Type` hunk; in 3.15 this is Argument Clinic, so Modules/clinic/_interpretersmodule.c.h was regenerated and no longer has the PyDict_Check).
- Modules/_interpretersmodule.c: restored the `updates != Py_None` + `PyObject_Size` + "non-empty mapping" check instead of `PyDict_Size` (reverses the second hunk).
- Python/crossinterp.c: removed `assert(PyDict_Check(nsupdates))` (reverses the third hunk).

Oracle failures: CommonTests.test_signatures (no TypeError "must be dict, not int"; `set___main___attrs(id, 1)` raises "object of type 'int' has no len()"), and test_invalid_shared_none (None is accepted/no TypeError).
