import inspect
from functools import cached_property

class P:
    @cached_property
    def foo(self):
        """doc from parent"""

class C(P):
    pass

class D(P):
    @cached_property
    def foo(self):
        pass

print(repr(inspect.getdoc(P.foo)))
print(repr(inspect.getdoc(C.foo)))
print(repr(inspect.getdoc(D.foo)))
