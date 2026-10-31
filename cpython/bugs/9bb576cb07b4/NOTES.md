Defines a class with a `functools.cached_property` in module `__main__` and prints the property's `__module__`.
Clean: `'__main__'` (copied from the wrapped function). Buggy: `'functools'` (the line copying `__module__` was removed).
