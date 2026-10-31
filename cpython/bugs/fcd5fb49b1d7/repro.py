def f(x):
    return [lambda: x for x in range(x)], x
fns, x = f(2)
print(x, [fn() for fn in fns])
