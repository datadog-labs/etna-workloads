# Rationale (gh-137576)

Hunks reversed:

1. `Python/pythonrun.c`: the fix added `get_interactive_filename()` and used it in `run_mod`. I removed the helper and restored the original `PyUnicode_FromFormat("%U-%zd", filename, count)`. Every interactive filename is again `<name>-N`, so `<stdin>` becomes `<stdin>-N`. PYTHONSTARTUP filenames become `path-N`, which collides with the interactive-source cache entries.
2. `Lib/traceback.py` (`format_frame_summary`): restored `startswith("<stdin>-")` in place of `startswith("<stdin-") and endswith('>')`. This matches the old naming from hunk 1. Both sides were changed together by the fix, so reverting them together keeps the old behaviour self-consistent.

Failing oracle case: `test_repl.TestInteractiveInterpreter.test_pythonstartup_error_reporting`. With PYTHONSTARTUP set, the traceback for `1/0` typed in the REPL shows the wrong source line (`print('from pythonstartup')` with `^^^`) instead of `1/0`.
