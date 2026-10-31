import _testcapi, sys

class A:
    def __init__(self):
        self.a = 1
        self.b = 2

sys.unraisablehook = lambda u: None
res = []
for n in range(20):
    a = A()
    d = a.__dict__
    exc = []
    sys.unraisablehook = lambda u: exc.append(u.exc_type)
    try:
        _testcapi.set_nomemory(n, n + 1)
        try:
            del a
        finally:
            _testcapi.remove_mem_hooks()
    except MemoryError:
        continue
    if MemoryError in exc:
        res.append(("a" in d, dict(d)))
print(res)
