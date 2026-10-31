Calls pure-Python `_pyio.BytesIO.write()` with an object whose `__buffer__` returns different data on each call.

Clean: the buffer is exported once, so the output is `1 3 b'01AAA56789' 5`.
Buggy: the buffer is exported twice, so the count, the returned length, the contents and the position differ.
