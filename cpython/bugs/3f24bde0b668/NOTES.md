Reproduces gh-118950 (test_connection_lost_when_busy). A mocked socket whose send() raises
BrokenPipeError backs an SSLProtocol/StreamWriter chain. After the first write fails, the second
write+drain should raise ConnectionResetError.
- clean: prints `ConnectionResetError`.
- buggy: the app transport's is_closing() ignores the underlying transport's state, so the second
  write does not raise; prints `no exception`.
