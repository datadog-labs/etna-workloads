from typing import *
T = TypeVar("T")
P = ParamSpec("P")

class X(Generic[P]):
    pass

Y = X[[int, T]]
print(Y.__parameters__)
print(repr(Y[str]))
