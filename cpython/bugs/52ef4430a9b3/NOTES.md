Creates an empty module file, then prints `linecache.getlines()` on it and `inspect.getsource()`/`getsourcelines()` of the imported module.
Clean: `['\n']`, `'\n'`, `(['\n'], 0)`. Buggy: `[]` and `OSError: could not get source code`.
