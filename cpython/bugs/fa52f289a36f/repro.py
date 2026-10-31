import _testcapi
try:
    print(repr(_testcapi.pytype_getmodulebydef(int)))
except BaseException as e:
    print(type(e).__name__, e)
