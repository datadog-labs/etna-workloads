# Rationale

Modules/fcntlmodule.c, `fcntl_fcntl_impl` and `fcntl_ioctl_impl`, in the
branch that copies a read-only bytes-like argument into a PyBytesWriter:
the error check `if (!async_err) { PyErr_SetFromErrno(...) }` is restored to
the pre-fix inverted form `if (async_err)`. This reverses fix hunks 1 and 3
(`if (async_err)` -> `if (!async_err)`). When fcntl()/ioctl() fails with a
real errno (not a signal handler exception), no OSError is set, but NULL is
returned.

I did not restore the missing `Py_DECREF(result)` on buffer overflow (fix
hunks 2 and 4). v3.15.2 uses PyBytesWriter, and the code already discards the
writer there, so that leak does not exist in this form.

## Oracle failures
`test_fcntl.test_bad_fd` (fcntl on a bad fd with a bytes arg) and
`test_ioctl.test_bad_fd` return NULL without an exception set. The debug
build aborts on that assertion, so the whole test files run incomplete
and all of their oracle cases are reported failing. In a release build the
result is a SystemError ("returned NULL without setting an exception")
instead of OSError.
