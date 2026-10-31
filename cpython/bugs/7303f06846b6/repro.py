import _ctypes
try:
    _ctypes.dlopen(b'missing\xff.so', 2)
except Exception as e:
    print(type(e).__name__)
