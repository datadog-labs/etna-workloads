from typing import get_type_hints

def f(x: int) -> str: ...
f.__wrapped__ = f
try:
    print(get_type_hints(f))
except ValueError as e:
    print("ValueError:", str(e).split(" at ")[0])
