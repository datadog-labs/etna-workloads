from typing import Generic, TypeVar
T = TypeVar("T")

class A(Generic[T]):
    def __setattr__(self, name, value):
        raise TypeError("no setattr")

print(type(A[int]()).__name__)
