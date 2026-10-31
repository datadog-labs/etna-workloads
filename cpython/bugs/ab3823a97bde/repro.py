import tokenize
print(sorted(n for n in ("open", "TokenError") if n in tokenize.__all__))
ns = {}
exec("from tokenize import *", ns)
print("open" in ns, "TokenError" in ns)
