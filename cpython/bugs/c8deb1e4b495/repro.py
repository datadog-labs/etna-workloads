def f():
    [x for x in [1]]
    return [x for _ in [1]]

x = 3
try:
    print(f())
except Exception as e:
    print(type(e).__name__, e)

ns = {"x": 3}
exec("[x for x in [1]]\ny = [x for _ in [1]]", ns)
print(ns["y"])
