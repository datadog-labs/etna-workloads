repro.py sets a running loop, swaps a DummyTask in via `_asyncio._swap_current_task`, then swaps it out with None and prints the returned task's type.
Clean: prints `DummyTask`, exit 0. Buggy: the injection drops the running-task reference and then returns it (refcount error), so the interpreter segfaults (exit -11).
