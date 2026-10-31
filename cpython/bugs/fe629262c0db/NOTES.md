Reproducer for gh-144050: `stat.filemode()` (pure-Python version, `_stat` blocked) must report "?" as the file type for unknown type bits.
With the bug, the type check uses `mode & bit == bit` instead of `S_IFMT(mode) == bit`, so 0o77777 and 0o177777 are misclassified (first char is a type letter such as 's' instead of '?').
