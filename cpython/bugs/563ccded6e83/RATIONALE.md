# Rationale

## Change: Lib/shutil.py, `_rmtree_safe_fd_step`
The fix narrowed `except Exception` to `except OSError` around the
lstat()/open() calls in the fd-based rmtree. In v3.15.2 that logic was
refactored into `_rmtree_safe_fd_step`, where a single trailing
`except OSError as err:` handler covers the lstat/open/fstat/scandir steps and
forwards to `onexc`. I changed that handler back to `except Exception as err:`,
so non-OSError exceptions (e.g. TypeError from invalid `path` or `dir_fd`) are
again swallowed by `ignore_errors=True` or passed to the error handler.

## Oracle failure
`test_shutil.TestRmTree.test_rmtree_errors`: `shutil.rmtree(None, ignore_errors=True)`
no longer raises TypeError (AssertionError: TypeError not raised by rmtree).
