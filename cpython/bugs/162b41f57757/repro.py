class Foo: pass
f = Foo()
f.__dict__["attr"] = 1
del f.__dict__

class StrSubclass(str): pass
print(hasattr(f, StrSubclass("attr")))

class Bar: pass
f.__class__ = Bar
print(isinstance(f, Bar))
print(f.__dict__)
