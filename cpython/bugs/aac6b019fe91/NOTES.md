Builds aliases (`Callable[[D], T]`, `typing.Dict[D, T]`) with a defaulted TypeVar before a non-default one.
Clean: prints the args. Buggy: `_GenericAlias.__init__` enforces default ordering for all origins, so TypeError ("non-default type parameter follows default").
