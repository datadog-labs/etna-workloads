import functools

class ro(functools.cached_property):
    def __set__(self, obj, value):
        raise AttributeError("read only property")

class Test:
    def __init__(self, prop):
        self._prop = prop

    @ro
    def prop(self):
        return self._prop

t = Test(1)
print(t.prop)
t._prop = 999
print(t.prop)
