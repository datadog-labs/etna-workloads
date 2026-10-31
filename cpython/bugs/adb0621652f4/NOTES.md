Reproducer: `X[[int, T]]` (Generic over a ParamSpec, substituted with a list containing a TypeVar), then `Y[str]`.
Clean: `__parameters__` is `(~T,)` and `Y[str]` prints `__main__.X[[int, str]]`.
Buggy: `_collect_type_parameters` no longer descends into tuples, so `__parameters__` is `()` and `Y[str]` raises `TypeError: ... is not a generic class`.
