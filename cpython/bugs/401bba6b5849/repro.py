import sys
sys.modules['_functools'] = None
import functools
print(functools.partial.__module__, functools.partial.__mro__[0].__name__)
try:
    alias = functools.partial[int]
    print(repr(alias), alias.__args__, alias.__parameters__)
except Exception as e:
    print(type(e).__name__, e)
