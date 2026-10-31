from typing import Generic, ParamSpec, TypeVar
T = TypeVar('T')
P = ParamSpec('P')
class MyCallable(Generic[P, T]):
    pass
print(repr(MyCallable[[int, str], bool]))
print(repr(MyCallable[[], bool]))
