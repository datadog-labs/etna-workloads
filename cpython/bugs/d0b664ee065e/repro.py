from typing import *
Ts = TypeVarTuple("Ts")
class Old(Generic[*Ts]): ...
PartOld = Old[int, *Ts]
print(PartOld[*tuple[str]].__args__)
for arg in (Unpack[list[int]], Unpack[List[int]]):
    try:
        PartOld[arg]
    except BaseException as e:
        print(type(e).__name__, e)
