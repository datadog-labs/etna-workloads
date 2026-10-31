Reproducer: the upstream test for gh-146613 (itertools.groupby grouper re-entrancy).
A key's __eq__ advances the grouper while _grouper_next is comparing tgtkey/currkey.
Clean: prints 1. Buggy: the compare no longer holds strong refs to the keys, so it hits a use-after-free (refcount assert/crash in the debug build).
