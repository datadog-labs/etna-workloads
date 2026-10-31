Deletes and re-adds the only key of a one-item dict while iterating over `d.values()` / `d.items()`.
Clean: RuntimeError "dictionary keys changed during iteration" after 1 iteration.
Buggy: no RuntimeError; the loop keeps yielding the re-added key (5 iterations here, then the dict entries run out).
