repro.py imports `_colorize` and prints which of {copy, re, inspect, typing} ended up in sys.modules (the lazy-import check from test_lazy_import).
Clean: `[]`. Buggy: `['re']`, because without `builtins.str` annotations in FancyCompleter, the `str: str` field annotations are resolved against the class namespace, eagerly importing `re`.
