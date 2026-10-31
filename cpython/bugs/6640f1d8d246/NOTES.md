Reproducer: traces `func` (`x = None; if x is None: ... else: ...; append(6)`), and at the last line sets `frame.f_lineno` back into the `else` branch.

The injection drops POP_JUMP_IF_NONE/NOT_NONE from the stack analysis in `frameobject.c`, so the jump is wrongly rejected.
- clean: the jump works, prints `[3, 5, 6]`.
- buggy: prints `ValueError can't jump into an exception handler, or code may be unreachable`, then `[3, 6]`.
