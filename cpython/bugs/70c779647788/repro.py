def b():
    [a for b in [1] for _ in []]
    return b, locals()
r, s = b()
print(r is b, list(s.keys()))

def f():
    def b():
        [a for b in [1] for _ in []]
        return b, locals()
    r, s = b()
    print(r is b, list(s.keys()))
f()
