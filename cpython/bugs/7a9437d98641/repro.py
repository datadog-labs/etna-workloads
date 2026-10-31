from typing import Union
U1 = Union[int, str]
for f in (lambda: U1 | float, lambda: U1 | "float", lambda: float | U1, lambda: "float" | U1):
    try:
        print(repr(f()))
    except Exception as e:
        print(type(e).__name__, e)
