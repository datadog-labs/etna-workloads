import ctypes, _imp, importlib.machinery

class Inittab(ctypes.Structure):
    _fields_ = [("name", ctypes.c_char_p), ("initfunc", ctypes.c_void_p)]

@ctypes.CFUNCTYPE(ctypes.py_object)
def init():
    return None

# Swap in an inittab that also contains a dotted name (as embedders may do).
ptr = ctypes.c_void_p.in_dll(ctypes.pythonapi, "PyImport_Inittab")
old = ctypes.cast(ptr, ctypes.POINTER(Inittab))
entries = []
i = 0
while old[i].name:
    entries.append((old[i].name, old[i].initfunc))
    i += 1
entries.append((b"pkg.sub", ctypes.cast(init, ctypes.c_void_p).value))
entries.append((None, None))
table = (Inittab * len(entries))(*entries)
ptr.value = ctypes.addressof(table)

spec = importlib.machinery.ModuleSpec("pkg.sub", importlib.machinery.BuiltinImporter)
try:
    print(_imp.create_builtin(spec))
except BaseException as e:
    print(type(e).__name__, e)
