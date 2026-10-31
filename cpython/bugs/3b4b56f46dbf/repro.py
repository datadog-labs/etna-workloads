from ctypes import c_byte, CField

try:
    CField(name="a", type=c_byte, byte_size=2, byte_offset=2, index=1,
           _internal_use=True)
except ValueError as e:
    print(repr(e))
