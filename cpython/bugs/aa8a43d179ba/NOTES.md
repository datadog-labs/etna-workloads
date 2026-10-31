Reproducer opens a FIFO via RotatingFileHandler(maxBytes=1) and calls shouldRollover/emit. Clean: False, data read 'hello
'. Buggy: io.UnsupportedOperation from stream.tell().
