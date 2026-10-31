Subclass of io.RawIOBase whose readinto() returns an out-of-range count (2 for a 1-byte buffer, or negative).
Clean: read() raises ValueError("readinto returned N outside buffer size 1").
Buggy: the count is not validated, so read() returns oversized/garbage bytes or a different error.
