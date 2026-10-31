Calls `shutil.rmtree('x', dir_fd='invalid')` with and without `ignore_errors=True`.
Clean raises TypeError both times. Buggy catches the TypeError with `except Exception`,
so with `ignore_errors=True` it is swallowed and the call returns normally ("no exception").
