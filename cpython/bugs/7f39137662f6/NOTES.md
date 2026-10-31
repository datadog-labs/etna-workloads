Creates a write-mode GzipFile around a temporary BytesIO, drops it, runs gc.collect(), with a sys.unraisablehook that prints.
Clean: prints only "done". Buggy: the GzipFile<->_WriteBufferStream reference loop lets the BytesIO close first, so an unraisable "ValueError: I/O operation on closed file." is reported.
