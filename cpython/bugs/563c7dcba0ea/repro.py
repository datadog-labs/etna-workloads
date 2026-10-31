def f():
    items = [([lambda: x for x in range(2)], lambda: x) for x in range(3)]
    return [([fn() for fn in fns], fn()) for fns, fn in items]
print(f())
