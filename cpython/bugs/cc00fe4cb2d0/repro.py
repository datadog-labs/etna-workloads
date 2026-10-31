import _testcapi
d = {}
d_copy = d.copy
try:
    _testcapi.set_nomemory(0)
    d_copy()
except MemoryError:
    print("MemoryError")
finally:
    _testcapi.remove_mem_hooks()
