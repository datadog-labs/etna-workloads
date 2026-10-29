Sets page_size=16384 and cache_size=2, then `PRAGMA cache_spill(-51)` and reads it back.
Clean shell reports 3 (51KiB / page size); the buggy one computes the negative
spill size from the cache size instead of the argument, so it reports a different value.
