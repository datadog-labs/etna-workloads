import gc
from dataclasses import dataclass

def make():
    @dataclass(slots=True)
    class SlotsTest:
        x: int
    return SlotsTest

C = make()
for _ in range(3):
    gc.collect()
print(len([c for c in object.__subclasses__() if c.__name__ == 'SlotsTest']))
