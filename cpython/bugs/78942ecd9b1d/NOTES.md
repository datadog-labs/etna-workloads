Reproducer: a socketpair transport whose protocol calls `pause_reading()` inside
`connection_made`, with data already pending on the peer.

Clean: the transport stays paused, so `data_received` is never called; prints `is_reading False`.
Buggy: `_add_reader` checks `_closing` rather than `is_reading()`, so the reader is registered
after the pause and `data_received b'x'` is printed despite the pause.
