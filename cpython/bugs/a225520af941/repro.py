from typing import Generic, TypeVar, List
T = TypeVar("T")

class NonType:
    def __mro_entries__(self, bases):
        return (Generic,)

class A(List[int], NonType()):
    pass
print([c.__name__ for c in A.__mro__])
