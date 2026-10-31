from typing import Generic, ParamSpec, TypeVar
T = TypeVar("T")
P = ParamSpec('P', default=...)
U = TypeVar("U", default=float)
class A(Generic[T, P, U]): ...
try:
    print(repr(A[float].__args__))
except TypeError as e:
    print("TypeError:", e)
