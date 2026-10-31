Raises an exception whose `__bool__` returns False, chained `from` a ValueError, and formats it with
TracebackException. Clean output includes the ValueError cause; the buggy build skips the cause/context
(and group subexceptions) because it tests `if e` instead of `if e is not None`.
