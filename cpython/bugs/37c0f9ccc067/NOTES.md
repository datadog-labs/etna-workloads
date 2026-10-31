Reproducer: MemoryHandler(flushOnClose=False), log one record, call logging.shutdown. Clean: nothing flushed; buggy: 'DEBUG buffered' is printed.
