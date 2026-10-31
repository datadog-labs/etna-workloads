import types
ns = {'__builtins__': types.MappingProxyType({'iter': iter}), 'x': iter([1, 2])}
print(repr(eval("x.__reduce__()", ns)))
ns = {'__builtins__': types.MappingProxyType({'__import__': lambda *a: a})}
exec("import foo.bar", ns)
print(repr(ns['foo'][0]))
