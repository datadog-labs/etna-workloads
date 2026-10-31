Reproducer: defines `class TD[UniqueT](TypedDict)` with `from __future__ import annotations` in a module, then prints `get_type_hints(TD)`.
Clean: `{'a': UniqueT}`. Buggy: `NameError name 'UniqueT' is not defined`, because the TypedDict's string annotation no longer gets its owner and the forward ref's module globals replace the type params.
