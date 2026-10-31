Reproducer for gh-122334 (static `_PyArg_Parser` not reset in `parser_clear`).

`repro.py` finds the `Programs/_testembed` binary next to the running interpreter's
build dir and runs `test_repeated_init_exec`, as test_embed does. That runs a snippet
(`_ssl.txt2obj(txt=..)`, `_queue.SimpleQueue().put_nowait(item=..)`,
`_zoneinfo.ZoneInfo.clear_cache(only_keys=..)`) across repeated
Py_Initialize/Py_Finalize cycles. It prints the output and the exit status.

Clean: all 4 loops print 1/2/3, exit 0.
Buggy: loop 1 is fine; loop 2 segfaults (exit -11) because the stale parser state
survives finalization.

It needs `_testembed` built in the build dir (embedding can't be done from pure Python).
