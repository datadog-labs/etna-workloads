# Rationale

## Lib/shutil.py, make_archive()
Reverses the fix's only implementation hunk: removes the `os.stat(root_dir)` /
`stat.S_ISDIR` check that raised FileNotFoundError (from stat) or
NotADirectoryError when `root_dir` was missing or not a directory. v3.15.2 still
had the identical block (plus an added `os.fspath(root_dir)` line, kept), so
removing it restores the pre-fix code path.

## Oracle failures
`test_make_tarfile_rootdir_nodir` and `test_make_zipfile_rootdir_nodir` fail
(both dry_run=False/True subtests; 4 failures): FileNotFoundError/NotADirectoryError
is no longer raised for a bad `root_dir`.
