Calls `_testcapi.Py_CompileStringExFlags` on `b"a=1 # type: \x80"` with PyCF_IGNORE_COOKIE|PyCF_TYPE_COMMENTS (the upstream test for gh-145783).
Clean: raises UnicodeDecodeError, prints "UnicodeDecodeError".
Buggy: the error from NEW_TYPE_COMMENT isn't propagated, so `_PyAST_Validate: Assertion '!PyErr_Occurred()' failed` aborts (exit 134).
