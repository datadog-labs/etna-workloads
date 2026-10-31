Registers a sys.monitoring PY_THROW callback `(code, offset, exc)` and throws IndexError into a suspended generator.
Clean: callback is called with 3 args and prints `throw gen IndexError()`, then `caught`.
Buggy: PY_THROW is dispatched with only 2 args, so the callback raises
`TypeError: on_throw() missing 1 required positional argument: 'exc'` (exit status 1).
