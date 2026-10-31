import itertools

def g():
    next(b)  # re-enter the tee while the lead iterator is fetching
    yield 1

a, b = itertools.tee(g())
try:
    print(list(a))
except RuntimeError as e:
    print("RuntimeError:", e)
