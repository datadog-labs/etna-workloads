# Rationale

Fix (gh-121499) made `select_item` (history navigation) invalidate the screen
refresh cache, so a multi-line history entry was fully re-rendered. In v3.15.2
the `RefreshCache.invalidated` flag no longer exists; the equivalent mechanism
is `select_item` calling `invalidate_buffer(0)`, which forces a rebuild from
buffer position 0 (no stale cached lines reused).

## Change
`Lib/_pyrepl/historical_reader.py`, `HistoricalReader.select_item`:
`self.invalidate_buffer(0)` -> `self.invalidate_buffer(self.pos)`.
Reverses the fix's `last_refresh_cache.invalidated = True` hunk: the cache is no
longer discarded after swapping the buffer, so lines before the new cursor
position (end of new entry) are reused from the stale cache of the old entry.
The other fix hunks (the flag, `valid`, `get_cached_location`) only support that
invalidation and have no separate equivalent here.

## Oracle failures
test_pyrepl.test_pyrepl: 2 failures, including `test_history_with_multiline_entries`:
screen shows `['def bar():', '    return 42', ' y = 2', ...]` instead of the `def foo()` entry
(stale lines from the previously displayed history entry).
