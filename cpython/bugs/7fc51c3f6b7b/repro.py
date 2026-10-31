from ctypes.util import find_library
try:
    print(repr(find_library("libc")))
except Exception as e:
    print(type(e).__name__)
