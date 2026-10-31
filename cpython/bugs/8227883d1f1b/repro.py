import gc, weakref, inspect

class Foo: pass
Foo.instance = Foo()
r = weakref.ref(Foo)
inspect.getattr_static(Foo.instance, 'whatever', 'irrelevant')
del Foo
gc.collect()
print(r() is None)
