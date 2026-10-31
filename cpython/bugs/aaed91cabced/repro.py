from enum import Enum

class Directions(Enum):
    DOWN_ONLY = frozenset({"sc"})
    UP_ONLY = frozenset({"cs"})
    UNRESTRICTED = frozenset({"sc", "cs"})

try:
    print(repr(Directions({"sc"})))
except Exception as e:
    print(type(e).__name__, e)
print({"sc"} in Directions)
