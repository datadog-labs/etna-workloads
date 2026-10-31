# Rationale

Changed `os_pathconf_impl` in `tree/Modules/posixmodule.c`: the fd/path dispatch is back to `if (path->fd != -1)` instead of `if (path->is_fd)`. This reverses the `os_pathconf_impl` hunk of the fix.

The `path_t.is_fd` field and its initialisation are kept. In v3.15.2 other functions (stat, chown, etc.) also use `is_fd`, so reversing those hunks would not be equivalent. Only the pathconf use is reverted.

With `os.pathconf(-1, name)`, the converter accepts -1 as an fd and sets `path->fd = -1`. The check `path->fd != -1` is then false, so the code calls `pathconf(path->narrow, name)` with `narrow == NULL`. That is a NULL dereference. The fixed code treats it as an fd and returns EBADF.

Oracle: `TestInvalidFD.test_pathconf_negative_fd_uses_fd_semantics` fails, and the run crashes (the test process ends in a fatal error). Many later oracle cases are then reported failing as an incomplete run.
