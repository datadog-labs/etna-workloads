Defines a class named `list` with a custom `__repr__` and calls `reprlib.repr()` on an instance.

Clean: prints `not builtins.list` (the `_lookup` module check rejects the shadowing class).
Buggy: `repr1` dispatches on the type name alone, calls `repr_list`, and raises `TypeError: object of type 'list' has no len()`.
