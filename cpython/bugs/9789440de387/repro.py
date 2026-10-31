import inspect
import _testcapi
meth = _testcapi.DocStringUnrepresentableSignatureTest.with_default
try:
    print(str(inspect.signature(meth)))
except Exception as e:
    print(type(e).__name__, e)
