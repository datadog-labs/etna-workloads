import warnings
warnings.simplefilter("ignore")
from ctypes import Structure, POINTER, c_int

lp = POINTER("node")

class node(Structure):
    _fields_ = [("value", c_int)]

lp.set_type(node)
print(repr(memoryview(lp(node(42))).format))
