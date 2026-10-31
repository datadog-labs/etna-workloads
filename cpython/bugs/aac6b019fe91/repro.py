import typing
from typing import Callable, TypeVar
D = TypeVar('D', default=int)
T = TypeVar('T')
for make in (lambda: Callable[[D], T], lambda: typing.Dict[D, T]):
    try:
        print(make().__args__)
    except TypeError as e:
        print("TypeError:", e)
