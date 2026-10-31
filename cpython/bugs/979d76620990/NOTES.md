Renders pydoc docs for a module containing a class whose method has `__module__ = None`.
Clean: prints `ok`. Buggy: `TypeError: unsupported operand type(s) for +: 'NoneType' and 'str'`
from pydoc's `_qualname`-style helper (missing `is not None` check).
