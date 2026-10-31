import typing
from typing import Union
try:
    print(hash(typing._UnionGenericAlias) == hash(Union))
except TypeError as e:
    print("TypeError:", e)
