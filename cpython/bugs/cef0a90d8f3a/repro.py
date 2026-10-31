import sys
from ctypes import Structure, c_char
n = sys.maxsize
class Z(Structure):
    _fields_ = [('largeField', c_char * n)]
print(Z.largeField.byte_size, Z.largeField.bit_size)
