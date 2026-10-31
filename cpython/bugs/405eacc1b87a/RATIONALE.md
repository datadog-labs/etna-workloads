# Rationale

Changed: `tree/Objects/typeobject.c`, `releasebuffer_call_python()`.
Removed `((PyMemoryViewObject *)mv)->flags |= _Py_MEMORYVIEW_RESTRICTED;`
(and its comment).

Reverses the fix hunk in `releasebuffer_call_python` that marks the temporary
memoryview passed to `__release_buffer__` as restricted. Without the flag, the
`CHECK_RESTRICTED` checks in memoryobject.c (cast, toreadonly, slicing,
`memoryview()`, `__buffer__`) never fire, so Python code can create new views
sharing the managed buffer and smuggle a reference past release. The checks
and the flag definition stay in place, as in the pre-fix state where they
did not exist.

Oracle failure: `TestPythonBufferProtocol.test_release_saves_reference`. The
`assertRaises(ValueError)` checks inside `__release_buffer__` fail, the
exception is swallowed as unraisable, `smuggled_buffer` is never set, and the
test then errors with `AttributeError: 'NoneType' object has no attribute 'tobytes'`.
