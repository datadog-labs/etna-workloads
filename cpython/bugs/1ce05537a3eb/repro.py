from ctypes import *
lib = CDLL(None)
proto = CFUNCTYPE(c_int, c_char_p, c_void_p)
func = proto(("printf", lib), ((1, "fmt"), (2, "out")))
for v in (123, (c_char_p, c_int)):
    try:
        func.argtypes = v
        print("no error")
    except Exception as e:
        print(type(e).__name__, e)
    print(func.argtypes)
