Seeks a BytesIO to sys.maxsize and calls readinto() on it (gh-141311).
Clean: prints 0 (EOF) and b'' for read. Buggy: the debug assert
`self->pos + len < PY_SSIZE_T_MAX` in readinto fails and the process aborts (SIGABRT).
