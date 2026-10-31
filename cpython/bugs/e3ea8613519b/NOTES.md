Reproducer: a real UDP datagram transport (selector loop) whose socket is wrapped
so `sendto` raises BlockingIOError until released. It prints
`get_write_buffer_size()` after queueing, while blocked, and after the send succeeds.

Clean: `sent 0`. Buggy: `sent 8`. The buggy `_sendto_ready` subtracts only
`len(data)` and not the 8-byte header it added in `sendto`, so the write buffer
size never returns to 0 (leaks 8 bytes per datagram).
