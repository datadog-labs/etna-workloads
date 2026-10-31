# RATIONALE

In v3.15.2 `Modules/posixmodule.c` already uses `path->is_fd` everywhere. I reverted the fix for the three functions the fix's NEWS entry names (listdir, scandir, listxattr), going back to the old `fd != -1` / `fd > -1` sentinel tests. Each is a one-line change.

- `_posix_listdir`: `path->is_fd` -> `path->fd != -1`. Reverses the fix hunk in `_posix_listdir`. `os.listdir(-1)` takes the path branch, and an fd of -1 is treated as "no fd", so it lists the cwd.
- `os_scandir_impl`: `iterator->path.is_fd` -> `iterator->path.fd != -1`. Reverses the matching hunk, so `os.scandir(-1)` scans the cwd.
- `ScandirIterator_closedir`: `iterator->path.is_fd` -> `iterator->path.fd != -1`. Reverses the matching hunk. It is consistent with the scandir change.
- `os_listxattr_impl`: `path->is_fd` -> `path->fd > -1` for the flistxattr dispatch, and `fd_and_follow_symlinks_invalid(..., path->is_fd, ...)` -> `path->fd`. `fd_and_follow_symlinks_invalid` still takes the `is_fd` parameter name, which now receives an fd value. A nonnegative fd is truthy, as in the old `fd >= 0` check. `os.listxattr(-1)` lists the cwd's xattrs.

## Oracle failures
`TestInvalidFD.test_negative_fd_ebadf` fails for `os.listdir`, `os.scandir` and `os.listxattr`, with fd -1 and fd -5 (the subtests show "OSError not raised"). `check.sh` reports 4 failures and 2 errors.
