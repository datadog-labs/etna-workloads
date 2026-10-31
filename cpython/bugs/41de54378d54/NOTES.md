Formats an object whose `__format__` returns its spec, using f-string specs containing
escapes (`\n`, `☃`). Clean prints `'\n'` and `'☃'`; the buggy build leaves the
escapes undecoded in the format spec (literal backslash sequences).
