repro.py calls `__setstate__` with a float and a str on a long range iterator (`range(10, 2**65, 2)`).
Clean: both raise `TypeError: state must be an int, not ...`.
Buggy: the float is silently accepted (no exception), and the str raises a different, uncaught-in-output-order TypeError (`'<' not supported ...`) from the comparison.
