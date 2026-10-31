repro.py forces the resource tracker's simple (colon-separated) format and creates/unlinks
SharedMemory segments whose names contain colons or a newline.

clean: prints "done" with no stderr output.
buggy: the tracker process fails to parse the messages (`_send` ignores the newline check, and
`_decode_message` uses `split(':')`), so it prints "ValueError: too many/not enough values to unpack"
tracebacks from resource_tracker.py to stderr. Exit status is 0 in both.
