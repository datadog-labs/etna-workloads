import _testcapi
flags = 0x0800 | 0x1000  # PyCF_IGNORE_COOKIE | PyCF_TYPE_COMMENTS
try:
    _testcapi.Py_CompileStringExFlags(b"a=1 # type: \x80", "<test>", 256, flags)
except UnicodeDecodeError as e:
    print("UnicodeDecodeError")
