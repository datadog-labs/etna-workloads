import ctypes

class BadType(ctypes._Pointer):
    pass

func = ctypes.pythonapi.Py_GetVersion
func.argtypes = (BadType,)
try:
    func(object())
except ctypes.ArgumentError as e:
    print("ArgumentError", e)
