import sys
def g():
    x = [1]
    yield sys._getframe()
it = g()
f = next(it)
it.close()
del it
print(f.f_locals)
print(f.f_back)
