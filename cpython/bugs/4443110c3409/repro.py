from __future__ import annotations
class f:
    x: int
print(f.__annotations__)
f.__annotations__ = {"x": str}
print(f.__annotations__)
