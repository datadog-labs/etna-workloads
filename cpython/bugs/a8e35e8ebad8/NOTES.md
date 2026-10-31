Runs two statements through `InteractiveColoredConsole.runsource`: `from __future__ import barry_as_FLUFL`, then `print("black" <> 'blue')`.
Clean: the console's compiler (which tracks future flags) is used, so `<>` works and prints True.
Buggy: plain `compile()` with stale flags is used, so the future flag isn't picked up and the `<>` line gives a syntax error (output differs).
