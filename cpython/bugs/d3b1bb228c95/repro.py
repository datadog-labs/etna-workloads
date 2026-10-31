from ctypes import _SimpleCData
PyCSimpleType = type(_SimpleCData)
try:
    class F(metaclass=PyCSimpleType):
        _type_ = "\0"
except Exception as e:
    print(type(e).__name__, repr(str(e)))
