from ctypes import *
try:
    c_char.from_param(b"abc")
except Exception as e:
    print(type(e).__name__, e)
try:
    c_wchar.from_param("abc")
except Exception as e:
    print(type(e).__name__, e)
