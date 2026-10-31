Calls os.listdir(-1), os.scandir(-1), os.listxattr(-1) and prints the outcome.
Clean: each raises OSError(EBADF). Buggy: the path_t fd check uses `fd != -1`,
so -1 is treated as a path and the current directory is listed (no error).
