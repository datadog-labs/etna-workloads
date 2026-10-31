Writes a module with `def bar():` followed by a comment and `pass`, then calls
`pdb.find_function("bar", "mod.py")`.
Clean returns `('bar', 'mod.py', 3)` (first executable line); buggy returns
`('bar', 'mod.py', 1)` (the `def` line), since the injection drops the
first-executable-line computation.
