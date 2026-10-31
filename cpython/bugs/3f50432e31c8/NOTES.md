Reproducer: create 3 channels with `_interpchannels`, force-close one, call `list_all()`.
Clean: prints 2. Buggy: segfault (exit -11), since list_all dereferences `ref->chan` (NULL for closed
channels) and uses `numopen` as the count.
