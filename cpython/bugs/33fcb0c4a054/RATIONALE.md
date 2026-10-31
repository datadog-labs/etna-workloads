# Rationale

Fix hunk reversed: the `#ifdef __linux__` check in `mmap_resize_method`
(Modules/mmapmodule.c) that raises ValueError when growing a shared
anonymous mapping (`fd == -1`, no `MAP_PRIVATE`, `new_size > size`).

In v3.15.2 this check had been extended to `__linux__ || __NetBSD__` and
the `flags` field already existed (also used elsewhere), so I only removed
the check block (the `flags` struct field and its assignment are kept since
other code now uses them). Without it, mremap() is called on a shared
anonymous mapping, as before the fix.

Failing oracle cases (test_mmap): `test_resize_up_anonymous_mapping` and
`test_resize_down_anonymous_mapping` (ValueError not raised when growing a
shared anonymous mmap on Linux).
