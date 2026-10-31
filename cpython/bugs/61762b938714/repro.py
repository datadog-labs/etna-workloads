import operator, weakref, sys

class C:
    pass

def f():
    ref = C()
    return weakref.ref(ref, exec)

sys.unraisablehook = lambda u: print("unraisable:", u.exc_type.__name__)
weak = operator.call(f)
print(weak())
