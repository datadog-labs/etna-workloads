import collections.abc
from typing import Protocol

collections.abc.Sized._abc_registry_clear()

class Foo(collections.abc.Sized, Protocol): pass

try:
    print(repr(isinstance(1, collections.abc.Sized)))
except TypeError as e:
    print("TypeError:", e)
