import _testcapi
class Obj: pass
obj = Obj()
obj.attr = 123
exc = ValueError("error")
for f in (_testcapi.object_setattr_null_exc, _testcapi.object_setattrstring_null_exc):
    try:
        f(obj, 'attr', exc)
    except BaseException as e:
        print(type(e).__name__, repr(e.__context__))
    print(hasattr(obj, 'attr'))
