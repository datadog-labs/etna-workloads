import linecache
from importlib.machinery import ModuleSpec

class FakeLoader:
    def get_source(self, fullname):
        return f'source for {fullname}'

spec = ModuleSpec('x.y.z', FakeLoader())
g = {'__name__': 'a.b.c', '__loader__': spec.loader, '__spec__': spec}
print(repr(linecache.getlines('scheme://path', g)))
