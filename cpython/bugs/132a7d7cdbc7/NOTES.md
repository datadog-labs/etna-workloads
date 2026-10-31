Reproducer: seeds `random.Random` with `b'nofar'` using `version=1` and prints the first four floats.
Clean: prints the Python 2.7-compatible values from test_bug_31482.
Buggy: the bytes decode step is missing, so `ord(a[0])` raises `TypeError: ord() expected string of length 1, but int found`.
