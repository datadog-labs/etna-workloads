from enum import Enum

class Cardinal(Enum):
    RIGHT = (1, 0)
    UP = (0, 1)
    LEFT = (-1, 0)
    DOWN = (0, -1)

print(repr(Cardinal(1, 0)))
print(repr(Cardinal(-1, 0)))
