from typing import Any

class Sub(Any):
    def __init__(self, *args, **kwargs): pass

try:
    Sub(0, s="")
    print("ok")
except TypeError as e:
    print("TypeError:", e)
