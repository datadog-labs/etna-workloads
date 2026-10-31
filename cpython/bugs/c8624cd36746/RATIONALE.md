# Rationale

Bug (gh-138860): `pdb` imported `rlcompleter` (and thus `readline`) at module import, which can deadlock subprocesses launched with process_group=0 / preexec_fn=setpgrp.

v3.15.2 already had a lazy `rlcompleter` property (a compromise with GH-139289), so the fix hunks don't reverse cleanly. Changes in `Lib/pdb.py`:

- Re-added top-level `from rlcompleter import Completer` (reverses the fix's removal of that import).
- Reduced the `Pdb.rlcompleter` property to `return Completer`, so the module-level class is used by `completedefault` and `_enable_rlcompleter` (reverses the fix's switch to a lazily imported, saved `Completer` class).

Failing oracle case: `test.test_pdb.PdbTestCase.test_readline_not_imported` — `import pdb` now imports readline, so "readline imported" is printed.
