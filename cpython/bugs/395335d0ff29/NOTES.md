repro.py: singledispatchmethod with instances that compare equal / have a bad __hash__.
Buggy build caches bound methods in a WeakKeyDictionary keyed by instance, so
`b.t(2) is b` is False (returns the cached `a`), and an unhashable/raising __hash__
makes `B().t(1)` raise AssertionError. Clean build prints True, True, ok.
