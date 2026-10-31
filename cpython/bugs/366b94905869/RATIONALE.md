# Rationale

Fix hunk (Lib/bdb.py, `Bdb.format_stack_entry`): guarded the `linecache.getline` call with `if lineno is not None`.

In v3.15.2 the guard exists, with an added `else` branch that appends a "Warning: lineno is None" note. I removed both the guard and the `else`, restoring the pre-fix code: an unconditional `linecache.getline(filename, lineno, frame.f_globals)`. The `else` only exists as part of that guard, so removing it is part of the same revert.

With `lineno=None`, linecache raises an unhandled exception again (gh-101517).

Oracle: `TestRegressions.test_format_stack_entry_no_lineno` fails. 16 other bdb cases also fail, because their expected traces go through `format_stack_entry` with a None lineno.
