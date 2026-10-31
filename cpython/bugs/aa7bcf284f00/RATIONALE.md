# Rationale

Fix: gh-116401 added `O_NONBLOCK` to the directory opens in `os.fwalk()` and `shutil.rmtree()`, so opening a FIFO doesn't block.
Both functions were refactored since, so the hunks don't apply. I removed the flag at the equivalent sites.

- `Lib/os.py` (`_fwalk`, `topfd = open(topname, O_RDONLY | O_NONBLOCK, dir_fd=dirfd)`): reverses the `os.py` fwalk hunks.
  The two original opens (top and child) are now one open in the iterative `_fwalk`.
- `Lib/shutil.py` (`_rmtree_safe_fd`, `topfd = os.open(name, os.O_RDONLY | os.O_NONBLOCK, ...)`): reverses the two `shutil.py` hunks.
  The two original opens are now one open in the iterative `_rmtree_safe_fd`.

Oracle: with a FIFO as the target (`test_walk_named_pipe*`, `test_rmtree_on_named_pipe`), `open()` without O_NONBLOCK blocks forever waiting for a writer, so these tests hang instead of raising NotADirectoryError or returning.
