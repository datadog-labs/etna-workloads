Allocates all available type watchers (ids 1-7; id 0 is taken), watches a class with the
last one (id 7, bit 0x80), then modifies the class.
With `tp_watched` as signed `char`, bit 0x80 sign-extends in `type_modified_unlocked`.
Clean: prints `True` (the event is delivered). Buggy: assertion `i < TYPE_MAX_WATCHERS`
fails in Objects/typeobject.c and the process aborts (exit -6).
