src = """
class __Base:
    def __init_subclass__(self, **kwargs):
        self.kwargs = kwargs

class Derived[T](__Base, __kwarg=1):
    pass
"""
ns = {}
try:
    exec(src, ns)
    print(ns["Derived"].__bases__[0] is ns["__Base"], ns["Derived"].kwargs)
except BaseException as e:
    print(type(e).__name__, e)
