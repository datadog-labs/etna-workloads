Builds a tar archive in memory, calls `tarfile.is_tarfile()` on a BytesIO and prints the result and `tell()`.
Clean prints `True` and position `0`. Buggy prints `True` and position `512`: `is_tarfile` doesn't restore the file position, so the file object can't then be read by `tarfile.open`.
