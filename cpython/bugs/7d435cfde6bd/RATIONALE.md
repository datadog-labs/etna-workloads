# Rationale

Fix hunk: `Lib/asyncio/selector_events.py`, `SelectorSocketTransport.writelines`
added a `_conn_lost` guard (log warning past threshold, increment, return)
before buffering data.

Change: removed that same guard block from `writelines` in v3.15.2 (the
surrounding code was rewritten for gh-155888, but the guard sat in the same place,
right after the `if not list_of_data: return`). `writelines` once again buffers
data and calls `_write_ready()` after the connection was lost.

Oracle failure: `SelectorSocketTransportTests.test_writelines_after_connection_lost`
fails with `AssertionError: deque([<memory ...>]) is not false` because data is
buffered after connection loss.
