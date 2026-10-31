Reproducer for gh-115514 (asyncio selector transport write after close).
A real socketpair transport has a large buffered write and low high-water mark (paused).
The protocol's resume_writing() writes more data. Then the transport is closed and the peer
reads to EOF.
Clean: all 1100000 bytes arrive and connection_lost(None) fires.
Buggy: close() sets _write_ready = None, so the later write() registers a None callback
("TypeError: 'NoneType' object is not callable" in the loop), the data is never flushed,
and the script times out (prints "timeout").
