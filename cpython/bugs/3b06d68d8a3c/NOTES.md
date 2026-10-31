Subclasses C `zoneinfo.ZoneInfo`, deletes `_weak_cache`, then calls `ZI("UTC")` and `ZI.clear_cache()`.
Clean: both raise AttributeError. Buggy: missing NULL check on get_weak_cache() -> crash (segfault/assert).
