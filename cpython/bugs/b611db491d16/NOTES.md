Subclass of zoneinfo.ZoneInfo whose `_weak_cache.get` returns a non-ZoneInfo (1337).
Clean: RuntimeError "Unexpected instance of int in ZI weak cache for key ...".
Buggy: the type check is missing, so the int is returned/cached as if it were a ZoneInfo.
