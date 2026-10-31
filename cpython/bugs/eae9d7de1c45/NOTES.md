`repro.py` calls `inspect.getsource()` on the code object of a multi-line generator expression.
Clean prints the whole 3-line expression. Buggy (the block finder no longer treats generator
expressions as single logical lines) stops after the first line: `ge = (x`.
