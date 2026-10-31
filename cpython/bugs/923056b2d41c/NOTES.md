Closes `p.stdin` before `Popen.communicate()`. Clean: communicate() returns `(b'', b'')`, returncode 0.
Buggy: `stdin.flush()` raises `ValueError: I/O operation on closed file` out of communicate().
