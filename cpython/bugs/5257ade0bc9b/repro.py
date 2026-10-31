from typing import Protocol, runtime_checkable

@runtime_checkable
class P(Protocol):
    __match_args__ = ('x', 'y')
    x: int
    y: int

class Regular:
    def __init__(self):
        self.x = 1
        self.y = 2

print(isinstance(Regular(), P))
