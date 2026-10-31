from types import GenericAlias
try:
    GenericAlias(bad=float)
except TypeError as e:
    print("TypeError", e)
