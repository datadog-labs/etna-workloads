import weakref
from typing import TypeVar
v = weakref.WeakValueDictionary()
for x in range(10):
    v[x] = TypeVar(str(x))
print(len(v))
del v
print("ok")
