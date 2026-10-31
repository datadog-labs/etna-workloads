# RATIONALE

Fix (gh-119443) changed the REPL's `runsource` to `compile(..., dont_inherit=True)` so the
`from __future__ import annotations` at the top of the REPL module is not inherited by user code.

In v3.15.2 that compile lives in `InteractiveColoredConsole.runsource` (`Lib/_pyrepl/console.py`),
and goes through `self.compile.compiler(...)` (`codeop.Compile`), which passes `dont_inherit=True`.
I reverted that call to the pre-fix form: the builtin `compile(item, filename, the_symbol, flags)`
(flags = the compiler's remembered flags, so explicit user `__future__` imports still persist) without
`dont_inherit`. The builtin therefore inherits console.py's `from __future__ import annotations`.

Failing oracle cases: `TestSimpleInteract.test_no_active_future` (annotations are stringified/deferred,
so the expected output `{'x': <class 'int'>}` is not printed), plus `test_future_barry_as_flufl`, a side effect: the builtin compile no longer goes through `codeop.Compile`, which is what remembers future flags

