# Rationale

Fix hunk reversed: the `lstat` branch in `realpath` that raises `ENOTDIR` in strict mode when a
non-directory is hit and path parts remain (`if strict and part_count and not S_ISDIR`).

In v3.15.2 (`Lib/posixpath.py`, `realpath`) that check is
`if (strict and (part_count or trailing_sep) and not stat.S_ISDIR(st_mode)): raise OSError(ENOTDIR...)`.
I removed the whole `if` block, so non-directories mid-path or with a trailing slash are accepted in
strict mode, as before the fix. `part_count` and `trailing_sep` bookkeeping is left in place (it is
still used by `ALL_BUT_LAST`).

Oracle failures: test_realpath_nonterminal_file, test_realpath_nonterminal_symlink_to_file,
test_realpath_nonterminal_symlink_to_symlinks_to_file (NotADirectoryError not raised for
`file/`, `file/.`, `file/..`, `file/subdir` in strict mode), and test_realpath_mode.
