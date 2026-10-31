from ctypes import pythonapi, py_object, c_char_p
f = pythonapi.PyErr_Format
f.argtypes = (py_object, c_char_p)
f.restype = py_object
try:
    f(ZeroDivisionError, b'\xff')
except BaseException as e:
    print(type(e).__name__, e)
