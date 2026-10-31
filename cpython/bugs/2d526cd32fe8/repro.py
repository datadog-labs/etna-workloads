from typing import Unpack, TypedDict, TypeVarTuple, Generic
Ts = TypeVarTuple('Ts')
print(repr(Unpack[Ts]))
print(repr(Unpack[tuple[int, str]]))
class M(TypedDict):
    a: int
print(repr(Unpack[M]))
class G(Generic[Unpack[Ts]]): pass
print(repr(G[Unpack[Ts]]))
