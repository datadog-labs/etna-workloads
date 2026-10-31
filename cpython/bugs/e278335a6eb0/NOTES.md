repro.py calls faulthandler.cancel_dump_traceback_later() without a prior dump_traceback_later().
Clean: prints "ok", exit 0. Buggy: the C code releases a NULL cancel_event lock, so the interpreter crashes (segfault/assert).
