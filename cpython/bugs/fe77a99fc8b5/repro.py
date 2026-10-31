ns = {}
exec("type A = int", ns)
print(repr(ns["A"].__module__))
