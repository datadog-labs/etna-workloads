import sys
sys.modules['_functools'] = None  # force the pure-Python functools
import functools
try:
    functools.lru_cache(1)('hello')
except TypeError as e:
    print('TypeError:', e)
