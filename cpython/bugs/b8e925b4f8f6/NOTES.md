Reproducer for the set_add_entry fix (gh, 2026-01-14), translated from `test_hash_collision_concurrent_add`.

A set holds a dummy slot followed by a hash-0 entry. Adding `Y()` calls `__eq__` during the probe, and that call re-entrantly adds another hash-0 object to the set. The fixed code restarts the probe when the remembered free slot has been filled. The buggy code skips that check and overwrites the slot.

- clean: prints `3`, `117`, `3`, `3` and exits 0.
- buggy: segfaults (exit status -11) before it prints anything.
