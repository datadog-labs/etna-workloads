repro.py parses f-strings with backslashes/quotes in the format spec, unparses them, re-parses, and compares AST dumps.
Clean: unparse escapes `\`, `'`, `"` in format specs, so the AST round-trips (True).
Buggy: escaping is missing, so unparse emits a different string. It gives a SyntaxWarning and the round-trip AST differs (False) for `f"{x:\\\\ }"` and `f"{x:\\'}"`.
