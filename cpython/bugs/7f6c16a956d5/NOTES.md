A progress handler (called every VM instruction) clears itself via
set_progress_handler(None, 0) and then raises. The injection removes the
incref/decref of the callback context around the call, so the context is freed
while still in use. Clean: prints "OperationalError interrupted" / "done", exit 0.
Buggy: segfault (exit -11).
