from typing import Protocol, runtime_checkable

class Bar[T]:
    x: T

class HasX(Protocol):
    x: int

try:
    runtime_checkable(Bar)
except TypeError as e:
    print("TypeError", e)

@runtime_checkable
class P(Protocol):
    x: int
try:
    print(issubclass(Bar, P))
except Exception as e:
    print(type(e).__name__, e)
