import ctypes
f = ctypes.pythonapi.PyErr_Occurred
f.argtypes = []
f.restype = ctypes.py_object
try:
    f()
except ValueError as e:
    print(repr(e))
