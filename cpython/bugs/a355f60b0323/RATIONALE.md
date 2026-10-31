# Rationale

Bug: gh-114914, `StreamReaderProtocol` kept an extra strong reference to the
server-side `StreamWriter`, so an abandoned writer was never collected and no
"unclosed <StreamWriter" ResourceWarning was emitted.

Changes (Lib/asyncio/streams.py), reversing the fix's hunks:
- `__init__`: re-add `self._stream_writer = None` (fix removed it).
- `connection_made`: store the writer as `self._stream_writer` and pass that
  to `client_connected_cb`, instead of using a local `writer` (fix hunk 3).
  Current code has a try/except around the callback; kept as is.

Not reverted: `_replace_transport` / `_replace_writer` (fix hunks 2 and 4).
In v3.15.2 the `_replace_writer` storage is not needed to reproduce the bug;
`connection_made` alone leaves the leak.

Oracle failure: `test_unclosed_server_resource_warnings` fails
(`AssertionError: 0 != 1`, no ResourceWarning because the writer stays alive
after `del wr; gc.collect()`).
