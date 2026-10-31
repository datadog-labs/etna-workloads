import sys
sys.modules['_functools'] = None
from functools import partial

class Builder:
    def __call__(self, tag, *children, **attrib):
        return (tag, children, attrib)

    def __getattr__(self, tag):
        return partial(self, tag)

m = Builder().m
print(repr(m(1, 2, a=2)))
