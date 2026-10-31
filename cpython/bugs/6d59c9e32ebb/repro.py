from typing import Protocol, runtime_checkable

class C:
    @property
    def attr(self):
        raise AttributeError('no')

class W:
    def __getattr__(self, name):
        raise RuntimeError("wut")

@runtime_checkable
class P(Protocol):
    @property
    def attr(self): ...

for k in C, W:
    try:
        print(k.__name__, isinstance(k(), P))
    except Exception as e:
        print(k.__name__, type(e).__name__, e)
