repro.py runs the test's source (print( with missing comma between string literals) via `python -c` in a subprocess and prints the return code and stderr.
Clean: "SyntaxError: invalid syntax. Perhaps you forgot a comma?"
Buggy: the traceback keyword-typo suggestion fires instead: "Did you mean 'not'?" (wrong location too).
