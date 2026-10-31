Binds a UNIX datagram socket to a path, closes it (leaving the stale socket file), then calls
`loop.create_datagram_endpoint(..., path, family=AF_UNIX)` on that same path.
Clean: the stale socket file is removed and binding succeeds ("bound over existing socket file").
Buggy: the removal is missing, so bind fails with "error: OSError Address already in use".
