Reproducer: write b'line1\r' to a file, open in text mode, readline(), then tell(), seek(), read().
Clean: prints 'line1\n', int, ''. Buggy: the debug assert in TextIOWrapper.tell() (textio.c:2951)
fires (abort, exit -6), because the injection changed the assert to compare skip_back instead of skip_bytes.
