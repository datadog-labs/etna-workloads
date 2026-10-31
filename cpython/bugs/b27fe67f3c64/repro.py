from typing import Protocol, runtime_checkable

@runtime_checkable
class P(Protocol):
    x = 1

class C:
    x = 1

P.register(C)
try:
    print(issubclass(C, P))
except TypeError as e:
    print("TypeError:", e)
