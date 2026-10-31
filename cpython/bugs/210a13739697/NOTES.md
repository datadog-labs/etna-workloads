Reproducer: cancel a pending `loop.sock_recv(a)`, then immediately start another `sock_recv(a)` on the same socket (before the cancelled future's done callback runs), then send data.

Clean: the second recv returns `b'hello'`.
Buggy: the cancelled recv's done callback (`_sock_read_done`) calls `remove_reader(fd)` and removes the *new* reader, so the second recv never completes (the script prints the timeout message after 2s).
