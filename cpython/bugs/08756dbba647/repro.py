import collections.abc, gc
from typing import Protocol

gc.disable()
try:
    class Foo(collections.abc.Mapping, Protocol):
        pass
except TypeError as e:
    print("TypeError:", e)
print(isinstance([], collections.abc.Mapping))
