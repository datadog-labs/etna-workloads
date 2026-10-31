Reproducer: symlinks the interpreter as `py`, writes `py._pth` (current sys.path plus
single-char lines `a`, `c` and a two-char line `bb`), runs `./py -S` and prints the last
three sys.path entries.
Clean: `['a', 'bb', 'c']`. Buggy: single-character lines are dropped by getpath's
readlines(), giving `['lib.linux-x86_64-3.15', 'site-packages', 'bb']`.
