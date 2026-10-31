Opens a streaming gzip tar for writing (`"w|gz"`) with a path-like object.
Clean: `tarfile._Stream` applies `os.fspath`, so it opens and prints the
stream's name (`'stream.tar'`). Buggy: `self.name = name or ""` keeps the
path-like object, so `AttributeError: 'P' object has no attribute 'endswith'`.
