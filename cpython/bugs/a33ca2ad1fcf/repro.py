import _testcapi
try:
    _testcapi.exc_set_object(OSError, PermissionError(24))
except BaseException as e:
    print(type(e).__name__, e.args)
