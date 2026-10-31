# gh-115514 reintroduced in Lib/asyncio/selector_events.py

Fix hunk reversed: `_SelectorSocketTransport._call_connection_lost` / `close`.

The fix moved `self._write_ready = None` out of `close()` and into the
`finally` of `_call_connection_lost()`, so the write handler stays alive while
a closed transport still drains its buffer. In v3.15.2 the `try/finally`
already exists (plus an unrelated `_read_ready_cb = None`), so I only:

- removed `self._write_ready = None` from the `finally` in
  `_call_connection_lost`;
- restored `self._write_ready = None` in `close()` (before `super().close()`).

Effect: `close()` with a non-empty write buffer nulls `_write_ready`
immediately, so the transport can no longer finish draining data (including
data the protocol adds during `resume_writing`, as SSLProtocol does) before
`connection_lost`. The writer callback then fails instead of flushing.

Oracle results from `./check.sh`:
- `test_selector_events.SelectorSocketTransportTests.test_write_buffer_after_close`
  fails (assertion), matching the fix's mock test.
- `test_ssl.TestSSL.test_remote_shutdown_receives_trailing_data_on_slow_socket`
  fails, as do 12 other test_ssl cases (the run was incomplete: crash/assert/timeout),
  so test_ssl is noisier than the upstream guard alone.
