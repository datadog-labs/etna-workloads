import _testcapi
for v in (2**31 - 1, 2**31, -2**31, -2**31 - 1):
    try:
        print(v, _testcapi.pylong_aspid(v))
    except Exception as e:
        print(v, type(e).__name__, e)
