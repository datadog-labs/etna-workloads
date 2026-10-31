repro.py ports test_pairwise_reenter2: the wrapped iterator's first __next__ re-enters pairwise.__next__ on the same object, for several maxcount values.
Clean prints `1 []`, `2 []`, `3 []`, `4 [(([2], [3]), [4])]`. The buggy build (no refcount protection of `old`, po->old overwritten without XSETREF) crashes with SIGSEGV (exit -11).
