An async generator is left suspended in a reference cycle, then gc.collect() runs in another thread
with the loop in debug mode. The finalizer hook must schedule aclose() thread-safely.
Clean: prints "done". Buggy: hook calls create_task directly from the other thread, so debug
`_check_thread` raises RuntimeError ("Exception ignored while finalizing generator"), and the aclose task is never run.
