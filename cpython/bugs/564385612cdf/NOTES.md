Instantiates `A[int]()` where `A(Generic[T])` defines `__setattr__` raising TypeError.
typing's `_GenericAlias.__call__` sets `__orig_class__` and should swallow any Exception.
Clean: prints `A`. Buggy: only AttributeError is caught, so TypeError propagates (traceback, exit 1).
