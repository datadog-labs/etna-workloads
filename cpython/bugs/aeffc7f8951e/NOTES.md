Reproducer: creates a regular file `EF` and calls `glob.glob(..., recursive=True)` with `EF/**` and `nonexistent/**`.
Clean: both print `[]`. Buggy: `_glob2` yields the empty match without checking the dirname is a directory, so it prints `['EF/']` and `['nonexistent/']`.
