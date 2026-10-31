import ctypes, struct, math
t = ctypes.c_double_complex
v = math.pi + 1j
for name in ("__ctype_le__", "__ctype_be__"):
    try:
        c = getattr(t, name)(v)
        print(name, bytes(c).hex(), c.value)
    except Exception as e:
        print(name, type(e).__name__, e)
print(struct.pack(">D", v).hex())
