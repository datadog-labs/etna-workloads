Reproducer: builds `Annotated[str, A("X")]` and `Annotated[str, B("X")]`, where A and B are distinct `str` subclasses, and prints the type name of each `__metadata__[0]`.

Clean: prints `A` then `B`. Buggy: prints `A` then `A`. The buggy build's `Annotated` goes through an untyped `_tp_cache`, so `A("X") == B("X")` gives a cache hit and returns the first result.
