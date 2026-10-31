import ctypes
f = ctypes.pythonapi.PyTraceMalloc_Track
f.argtypes = [ctypes.c_uint, ctypes.c_size_t, ctypes.c_size_t]
print(f(123, 10, 1))
u = ctypes.pythonapi.PyTraceMalloc_Untrack
u.argtypes = [ctypes.c_uint, ctypes.c_size_t]
print(u(123, 10))
