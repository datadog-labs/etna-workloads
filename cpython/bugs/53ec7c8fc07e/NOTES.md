Reproducer for gh-142214 (dataclasses regressions). It checks:
1. `@dataclass(slots=True, init=False)` – buggy build raises AttributeError (object.__init__ has no `__annotate__`); clean prints `10 False`.
2. Annotations of `__init__` when the class `__annotate__` returns `{}` – buggy build raises KeyError; clean prints `{'return': None}`.
