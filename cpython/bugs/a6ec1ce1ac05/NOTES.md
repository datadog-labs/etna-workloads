Reproducer: reads a line from a `codecs.EncodedFile` (StreamRecoder), seeks to 0, and reads all lines again.
Clean: seek() is propagated to the reader and resets its buffer, so line1..line3 are re-read correctly.
Buggy: seek() isn't propagated to the reader, so stale buffered data is left and the re-read lines are wrong.
