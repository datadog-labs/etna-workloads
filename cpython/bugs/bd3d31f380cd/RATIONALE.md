# Rationale

Fix hunks (gh-87320) wrapped the call to a non-default `sys.excepthook` in a helper
(`_call_excepthook`) that catches `BaseException` (re-raising `SystemExit`), prints
"Error in sys.excepthook:" and the "Original exception was:" report.
In v3.15.2 that logic lives inline in `InteractiveInterpreter._showtraceback` (Lib/code.py),
shared by showsyntaxerror/showtraceback.

Change: replaced the try/except block with a bare `sys.excepthook(typ, value, tb)`,
the pre-fix behaviour: exceptions from a custom excepthook bubble up and end the REPL.

Failing oracle cases (test_code_module): `test_sysexcepthook_crashing_doesnt_close_repl`
and `test_sysexcepthook_raising_BaseException` error with the hook's exception escaping
`interact()`. (`..._SystemExit_gets_through` still passes, as before the fix.)
