from typing import Protocol, runtime_checkable

@runtime_checkable
class P(Protocol):
    def meth(self): ...

class DeferredClass:
    x: undefined

class Impl:
    x: undefined | int
    def __init__(self):
        self.x = 0
    def meth(self): ...

class SubProtocol(P, Protocol):
    meth: undefined

print(issubclass(SubProtocol, P))
for c in (DeferredClass, Impl):
    try:
        print(isinstance(c(), P))
    except BaseException as e:
        print(type(e).__name__, e)
