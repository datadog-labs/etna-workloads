from typing import Protocol, runtime_checkable

@runtime_checkable
class HasX(Protocol):
    x = 1

    @classmethod
    def __subclasshook__(cls, other):
        return hasattr(other, 'x')

class Empty: pass

class ImplementsHasX:
    x = 1

print(issubclass(ImplementsHasX, HasX))
print(issubclass(Empty, HasX))
