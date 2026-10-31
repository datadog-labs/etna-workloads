linecache.getlines with module_globals whose `__spec__.name` ('x.y.z') differs from `__name__` ('a.b.c').
Clean passes `__spec__.name` to the loader's get_source -> `['source for x.y.z\n']`; buggy uses `__name__` -> `['source for a.b.c\n']`.
