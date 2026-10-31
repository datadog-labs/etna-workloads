from typing import get_type_hints
ns = {}
exec("""
from __future__ import annotations
from typing import TypedDict
class Base(TypedDict):
    base: int
class Child(Base):
    child: int
""", ns)
Child = ns["Child"]
print(repr(Child.__annotations__))
print(repr(get_type_hints(Child)))
