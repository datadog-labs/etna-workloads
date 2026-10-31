Reproducer for gh-142783 (zoneinfo use-after-free). A ZoneInfo subclass gets a `_weak_cache`
descriptor whose `__get__` returns a fresh dict. The buggy `get_weak_cache` returns a borrowed
reference to that temporary dict, so it is freed while still in use.
Clean: prints the key twice and `False`, exit 0. Buggy: debug-build assertion failure/abort (SIGABRT, -6).
