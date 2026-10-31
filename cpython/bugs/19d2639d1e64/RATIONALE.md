# Rationale

Fix hunk (Lib/asyncio/selector_events.py, `SelectorSocketTransport.writelines`) added, after `self._write_ready()`,
a check that registers the write handler when data is still buffered. In v3.15.2 this became
`self._add_writer(self._sock_fd, self._write_ready)` (followed by `_maybe_pause_protocol()`).
I removed only that `_add_writer` call (and its comment), keeping `_maybe_pause_protocol()`, which is unrelated to the fix.
Result: a partial send in `writelines` leaves the remaining buffer with no writer registered, so it is never flushed.

Failing oracle cases (3): `test_writelines_send_partial`, `test_writelines_sendmsg_partial`, and one more
`test_writelines_*` in SelectorSocketTransportTests; each fails with `AssertionError: {} is not true` on `self.loop.writers`.
