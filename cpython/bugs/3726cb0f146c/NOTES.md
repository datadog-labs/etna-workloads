Compiles `a/build/real/path/m.py` with `stripdir="a/build/fake"` (not a valid prefix) and prints the `co_filename` stored in the .pyc.
Clean: stripdir is ignored, so the filename stays `a/build/real/path/m.py`.
Buggy: matching components are removed piecemeal, so it prints `real/path/m.py`.
