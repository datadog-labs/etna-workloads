repro.py defines an ast.AST subclass whose `_fields` holds a bytes object that is missing from `_field_types`, then instantiates it.
Clean: raises TypeError "Field b'\xff...' is missing from BadFields._field_types".
Buggy: the message format uses `'%U'` on a non-str, so the debug build hits an assertion failure (Fatal Python error: _PyObject_AssertFailed).
