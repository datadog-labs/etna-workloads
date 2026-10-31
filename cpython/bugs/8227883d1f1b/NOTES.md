Mirrors test_cache_does_not_cause_classes_to_persist (gh-118013): calls inspect.getattr_static on an
instance, deletes the class, gc.collects, and prints whether the class was freed.
Clean: True. Buggy: False (the lru_cache in _shadowed_dict holds strong refs to the class).
