Reproducer: a RESP3 client authenticates as a user with channel `&test`, subscribes, then runs
`ACL SETUSER <itself> resetchannels`, so the client removes its own channel permission.
Clean (9.0.7): the client is closed later (freeClientOrCloseLater), the server stays up, and the script prints PONG.
Buggy: the current client is freed immediately inside its own command, so the server segfaults.
The script prints "DOWN" and "CRASH", and bash reports the segfault.
