def f():
    pass

f.__defaults__ = (None,)
for _ in range(1025):
    f()
print("done")
