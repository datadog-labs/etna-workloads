repro.py imports the pure-Python `functools` (by blocking `_functools`) and calls `lru_cache(1)('hello')`, i.e. decorates a non-callable.
Clean: raises `TypeError: the first argument must be callable`, which the script prints.
Buggy: the callable check is missing, so no exception is raised and nothing is printed.
