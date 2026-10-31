from __future__ import annotations
from typing import get_type_hints

class T:
    pass

def f[T](x: T) -> T:
    pass

print(get_type_hints(f)["x"] is f.__type_params__[0])
