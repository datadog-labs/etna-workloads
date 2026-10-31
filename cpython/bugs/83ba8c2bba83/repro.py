import inspect

_global_ref = "global"

class C:
    _global_ref = object()

def f():
    print(C._global_ref, _global_ref)

r = inspect.getclosurevars(f)
print(sorted(r.globals), sorted(r.builtins), sorted(r.unbound))
