import typing
from dataclasses import dataclass

T = typing.TypeVar('T')

@dataclass(slots=True, weakref_slot=True)
class A(typing.Generic[T]):
    pass

print(A.__slots__)
print(bool(A.__weakref__))
A()
