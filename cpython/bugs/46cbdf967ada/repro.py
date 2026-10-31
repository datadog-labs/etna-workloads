import gc
from dataclasses import dataclass

def simple():
    @dataclass(slots=True)
    class SlotsTest:
        pass
    return SlotsTest

def frozen():
    @dataclass(frozen=True, slots=True)
    class SlotsTest:
        pass
    return SlotsTest

def ann():
    @dataclass(slots=True)
    class SlotsTest:
        x: int
        def method(self) -> int:
            return self.x
    return SlotsTest

def fwd():
    @dataclass(slots=True)
    class SlotsTest:
        x: undefined
        y: list[undefined]
    return SlotsTest

for make in (simple, frozen, ann, fwd):
    C = make()
    gc.collect()
    print(make.__name__, len([c for c in object.__subclasses__() if c.__name__ == 'SlotsTest']))
