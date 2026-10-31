Calls `tempfile.mkdtemp(dir=".")` and prints whether the result is absolute.
Clean: True. Buggy: False (relative path returned, fix's abspath() missing).
