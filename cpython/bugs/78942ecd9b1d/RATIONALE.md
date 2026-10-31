# Rationale

In v3.15.2 the fix's moves of `is_reading`/`pause_reading`/`resume_reading` and
`_paused` into `_SelectorTransport` are still present. The behaviour that made
the bug is the reader registration, so only that is reverted.

## Lib/asyncio/selector_events.py: `_SelectorTransport._add_reader`
Reverses the fix hunk `if self._closing:` -> `if not self.is_reading():`.
Back to `if self._closing:`. A reader registered after `pause_reading()` (e.g.
the deferred `_add_reader` scheduled by the constructor, which runs after
`connection_made` paused reading) is no longer suppressed, so reading restarts
despite the pause.

## Lib/asyncio/unix_events.py: `_UnixReadPipeTransport.__init__` and `_add_reader`
Reverses the hunks that added `_UnixReadPipeTransport._add_reader` (which skips
when not `is_reading()`) and made the constructor schedule it. The constructor
again schedules `self._loop._add_reader` directly, and the helper is removed.
This is the same defect on the pipe path: a pause in `connection_made` is
overridden. (`pause_reading`'s use of `is_reading()` is left alone, since it is
behaviourally equivalent.)

## Oracle
`test_selector_events.SelectorSocketTransportTests.test_pause_reading_connection_made`
fails with `AssertionError: fd 7 is registered`: the reader is still registered
after `connection_made` paused reading.
