import gc, weakref

class MyObject:
    pass

m = memoryview(b'abc').__buffer__(0)
o = MyObject()
o.m = m
o.o = o
wr = weakref.ref(o)
del m, o
gc.collect()
print(wr())
