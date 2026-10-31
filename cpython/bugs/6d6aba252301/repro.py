import sys, types
m = types.ModuleType("mod")
sys.modules["mod"] = m
exec("""
from __future__ import annotations
from typing import TypedDict
class TD[UniqueT](TypedDict):
    a: UniqueT
""", m.__dict__)
TD = m.TD
from typing import get_type_hints
try:
    print(get_type_hints(TD))
except Exception as e:
    print(type(e).__name__, e)
