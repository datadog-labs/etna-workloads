from functools import lru_cache

@lru_cache()
def f(x):
    pass

f(0)
f(0, **{})
print(f.cache_info())
