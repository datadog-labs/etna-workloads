import weakref, gc

class Foo:
    pass

f = Foo()
f_wr = weakref.ref(f)

def genfn():
    a = f
    yield

g = genfn()
next(g)
del f
g.close()
gc.collect()
print(f_wr() is None)
