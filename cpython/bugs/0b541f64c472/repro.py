import sys
from ctypes import *
if sys.byteorder == "little":
    _Structure, _Union = BigEndianStructure, BigEndianUnion
else:
    _Structure, _Union = LittleEndianStructure, LittleEndianUnion

class S1(_Structure):
    _fields_ = [("a", c_byte), ("b", c_byte)]

try:
    class U1(_Union):
        _fields_ = [("s1", S1), ("ab", c_short)]
    class S2(_Structure):
        _fields_ = [("u1", U1), ("c", c_byte)]
    print(sizeof(U1), sizeof(S2))
except Exception as e:
    print(type(e).__name__, e)
