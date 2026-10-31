from ctypes import Structure, CDLL, c_double
from ctypes.util import find_library

class Base(Structure):
    _fields_ = [('y', c_double), ('x', c_double)]
class Mid(Base):
    _fields_ = []
class Vector(Mid):
    pass

libm = CDLL(find_library('m'))
libm.atan2.argtypes = [Vector]
libm.atan2.restype = c_double
print(libm.atan2(Vector(y=0.0, x=-1.0)))
