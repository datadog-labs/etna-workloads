from ctypes import POINTER, Structure, c_int

class C(Structure):
    _fields_ = [('a', c_int)]

ptr = POINTER(C)
for i in range(5):
    ptr._type_
ptr.set_type(c_int)
print(ptr._type_)
