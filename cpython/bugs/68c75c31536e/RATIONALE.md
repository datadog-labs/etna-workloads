# Rationale

Fix (gh-105035) made `LOAD_SUPER_ATTR_METHOD` pass `&method_found` to
`_PySuper_Lookup` only when the type's `tp_getattro` is `PyObject_GenericGetAttr`,
else NULL. In v3.15.2 this guard is
`Py_TYPE(self)->tp_getattro == PyObject_GenericGetAttr ? method_found_ptr : NULL`.

Reverted by always passing `method_found_ptr` (pre-fix: always `&method_found`) in:
- Python/bytecodes.c (`_LOAD_SUPER_ATTR_METHOD`)
- Python/generated_cases.c.h and Python/executor_cases.c.h (generated copies, edited consistently; no line-number shifts since the line count is unchanged apart from the one-line collapse in the call arguments)

With the guard gone, types with a custom `tp_getattro` get an unbound method plus
self pushed, bypassing the custom getattro semantics (descriptors are not bound).

Oracle: `./check.sh` shows test_super failing (2 errors, 1 failure), e.g.
`test_mixed_staticmethod_hierarchy` (staticmethod receives an extra arg) and
the new-style unusual-getattro cases.
