Reproducer: builds a Union of classes with an unhashable metaclass (`A | B`, `typing.Union[A, B]`)
and a union of Annotated types with unhashable metadata (`{}`, `set()`), printing `__args__`/`get_args`.
Clean: unions are created fine (args printed). Buggy: union creation raises
`TypeError: unhashable type` because deduplication requires hashing the args.
