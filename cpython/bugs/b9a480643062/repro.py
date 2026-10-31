from ctypes import CField, c_byte
try:
    CField(name="x", type=c_byte, byte_size=1, byte_offset=0, index=0,
           _internal_use=True, bit_size=7, bit_offset=2)
except ValueError as e:
    print(repr(str(e)))
