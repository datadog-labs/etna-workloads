import _ctypes_test
from ctypes import PyDLL, c_int, c_void_p, py_object, Structure

class Y(Structure):
    _fields_ = [("a", c_void_p), ("b", c_void_p)]

    def __del__(self):
        trace.append(4)

    @classmethod
    def from_param(cls, value):
        trace.append(2)
        return cls()

f = PyDLL(_ctypes_test.__file__)._testfunc_pylist_append
f.restype = c_int
f.argtypes = [py_object, py_object, Y]

trace = []
trace.append(1)
f(trace, 3, "dummy")
trace.append(5)
print(trace)
