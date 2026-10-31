# Rationale

Fix hunk (Lib/pdb.py, `Pdb.__init__`): `if stdout: use_rawinput = 0` became `if stdin: use_rawinput = False`.
In v3.15.2 the line is `if stdin is not None and stdin is not sys.stdin:`. I restored the pre-fix
condition `if stdout:` (Lib/pdb.py:504), so `use_rawinput` follows `stdout` rather than `stdin`.

With `pdb.Pdb(stdin=StringIO(...))` and no stdout, `use_rawinput` stays true, so commands are read
from the real terminal input instead of the supplied stdin.

Failing oracle case: `test.test_pdb.PdbTestInline.test_alternate_stdin` (BdbQuit, "42" not in stdout).
