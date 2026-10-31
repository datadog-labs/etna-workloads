import marshal
fset = frozenset([int])
try:
    marshal.dumps(((fset,), memoryview(b'')))
except ValueError as e:
    print(repr(e))
