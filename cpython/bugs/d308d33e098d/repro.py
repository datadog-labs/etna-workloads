from typing import ClassVar, Final
try:
    print(repr(ClassVar[Final[int]]))
    print(repr(Final[ClassVar[int]]))
except TypeError as e:
    print("TypeError:", e)
