Reproducer: `**=` with an `__ipow__` returning NotImplemented, and `None **= 2`.
Clean: falls back to `__rpow__` (prints 1) and error says "unsupported operand type(s) for **=: ...".
Buggy: no fallback (TypeError raised) and error message says "** or pow()" instead of "**=".
