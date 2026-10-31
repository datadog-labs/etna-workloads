from typing import TypeVar, TypeAliasType

for tp in [(1,), (TypeVar("T"), 2)]:
    try:
        TypeAliasType("A", int, type_params=tp)
        print("no error")
    except TypeError as e:
        print("TypeError:", e)

D = TypeVar("D", default=int)
N = TypeVar("N")
try:
    TypeAliasType("A", int, type_params=(D, N))
    print("no error")
except TypeError as e:
    print("TypeError:", e)
