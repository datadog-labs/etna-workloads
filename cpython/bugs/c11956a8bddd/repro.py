from typing import Protocol

class P(Protocol):
    x: int

class Foo(P):
    def __init__(self):
        super().__init__()

try:
    Foo()
    print("ok")
except RecursionError as e:
    print("RecursionError")
