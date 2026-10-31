from typing import NamedTuple

class A:
    def __radd__(self, other):
        return "radd"

class B(tuple): ...

class T(NamedTuple):
    x: int

for v in [(), B(), (1,), T(x=1)]:
    try:
        print(repr(v + A()))
    except Exception as e:
        print(type(v).__name__, type(e).__name__, e)
