from typing import ClassVar, Final

for obj in (ClassVar[int], Final[int]):
    try:
        class C(obj):
            pass
        print("no error", C.__bases__)
    except TypeError as e:
        print("TypeError", e)
