class X:
    def __hash__(self):
        return 1
    def __eq__(self, other):
        d.clear()

d = {}
for _ in range(10):
    d[X()] = None
print(len(d))

d = {}
for _ in range(10):
    d.setdefault(X(), None)
print(len(d))
