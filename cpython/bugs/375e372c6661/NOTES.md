Reproducer for gh-143689: `BufferedReader.read1(huge)` raises MemoryError when allocating
the output buffer. The buggy build returns without releasing the buffered lock, so the next
`read1(1)` fails with `RuntimeError: reentrant call`. The clean build prints `b'h'`.
