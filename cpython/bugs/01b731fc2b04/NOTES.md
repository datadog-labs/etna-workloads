Calls `difflib._mdiff(["2"], ["3"], 1)`. Clean prints the single diff tuple; buggy lets the StopIteration from `next()` inside the generator escape, so it raises RuntimeError (PEP 479).
