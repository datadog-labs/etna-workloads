Reproducer for the `_asynciomodule.c` future_schedule_callbacks bug (gh-125969).
A fake loop's `call_soon` calls `fut.remove_done_callback()` during scheduling,
so the callbacks list shrinks while the C code iterates it.
Clean: prints `done`, exit 0. Buggy: segfault (exit -11), reading past the shrunken list.
