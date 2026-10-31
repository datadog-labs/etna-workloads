# Rationale

Fix hunk (Lib/socket.py, `socketpair` fallback): added authentication of the
loopback connection via `getsockname()`/`getpeername()` comparison, raising
`ConnectionError("Unexpected peer connection")` and closing both sockets.

In v3.15.2 the fallback was refactored into a module-level helper, and the
check is guarded by `sys.platform != "wasi"`. I removed that whole block
(comment, guard and try/except) from `Lib/socket.py`, so the pure-Python
fallback returns `(ssock, csock)` right after `accept()` without verifying that
the accepted connection is really the peer of `csock`. This is the pre-fix
behaviour.

## Oracle failures

`test.test_socket.PurePythonSocketPairTest.test_injected_authentication_failure`
fails with `AssertionError: OSError not raised`: the injected mismatched peer
is accepted instead of being rejected.
