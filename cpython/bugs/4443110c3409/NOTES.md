Class under `from __future__ import annotations` stores `__annotations__` directly in its dict.
Assigning `f.__annotations__ = {...}` should replace it. The buggy build writes only
`__annotations_cache__`, so the old value is still returned: `{'x': 'int'}` instead of `{'x': <class 'str'>}`.
