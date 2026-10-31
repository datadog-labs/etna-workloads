Reproducer builds a package where a.py annotates `v1`, imports b, then annotates `v2`;
b.py reads `a.__annotations__` while a is still initializing. It then prints
`a.__annotations__` and `b.annos`.

Clean: `{'v1': int, 'v2': int}` / `{'v1': int}`.
Buggy: `{'v1': int}` / `{'v1': int}` (the partial annotations were cached, so `v2` is lost).
