# Rationale

Fix hunk: `Lib/asyncio/selector_events.py`, `_SelectorSocketTransport.writelines` gained `self._maybe_pause_protocol()` after registering the write handler when data remains buffered.

In v3.15.2 the code has moved (`self._add_writer(...)` instead of `self._loop._add_writer(...)`), so a literal reverse doesn't apply. I removed the `self._maybe_pause_protocol()` call after `self._add_writer(self._sock_fd, self._write_ready)` in `writelines`. This restores the pre-fix code: `writelines` never pauses the protocol when the buffer passes the high-water mark.

Oracle failure: `SelectorSocketTransportTests.test_writelines_pauses_protocol` fails with `AssertionError: False is not true`, because `protocol.pause_writing` is never called.
