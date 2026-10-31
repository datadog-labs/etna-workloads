# Rationale

Fix hunk reversed: `Lib/code.py` `InteractiveInterpreter.showsyntaxerror`, which in the
fix gained `source = kwargs.pop('source', "")` and passes `source` to `_showtraceback`.
In v3.15.2 that code remains (the `_pyrepl/console.py` override and `runsource` callers
already pass `source=`), so reversing the hunks no longer applied. I restored the pre-fix
behaviour at the single point where the source is consumed: `showsyntaxerror` ignores the
`source` kwarg and passes `""`, so `_showtraceback` never fills in `value.text`. Syntax
errors from the REPL without text then show no source line or caret location.

Failing oracle case: `TestSimpleInteract.test_runsource_show_syntax_error_location`
(`def f(x, x): ...` no longer prints the source line and caret).
