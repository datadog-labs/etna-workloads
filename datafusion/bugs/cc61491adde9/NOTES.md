repro.sql runs `select median(NULL), arrow_typeof(median(NULL));`.
Clean build: returns NULL with type Null. Buggy build: fails with "This feature is not implemented: MedianAccumulator not supported for median(NULL) with Null" (untyped NULL input no longer handled in median).
