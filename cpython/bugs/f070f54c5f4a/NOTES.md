repro.py creates a subinterpreter via `_interpreters` and prints `contextvars.Token.MISSING` from inside it.
Clean: prints `<Token.MISSING>`. Buggy: `_PyContext_Init` skips non-main interpreters, so the attribute is missing and it prints `doesn't exist`.
