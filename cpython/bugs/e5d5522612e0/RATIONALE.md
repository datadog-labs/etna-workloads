# Rationale

Fix (gh-106917) changed the `method_found` guard in `LOAD_SUPER_ATTR_METHOD`
from `cls->tp_getattro` to `Py_TYPE(self)->tp_getattro`. In v3.15.2 the line
lives in `_LOAD_SUPER_ATTR_METHOD`; I reverted it back to `cls->tp_getattro` in:

- Python/bytecodes.c (source)
- Python/generated_cases.c.h (generated copy, edited identically)
- Python/executor_cases.c.h (generated copy, edited identically)

Each corresponds to the fix's three hunks. When `self` is a type (classmethod-style
super call), the check looks at the metaclass-level getattro of `cls` instead of
`self`'s type, so a non-classmethod target is treated as a method and called with an
extra argument.

## Oracle failures
Running `./check.sh`: test_super reports 1 failure and 1 error, including
`test_mixed_staticmethod_hierarchy` (extra `cls` arg passed to the staticmethod,
`AssertionError: (<class C>,) is not false`) and `test_reassigned_new`.
