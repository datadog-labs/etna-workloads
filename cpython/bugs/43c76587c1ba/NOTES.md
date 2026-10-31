Reproducer: create an instance with `attr1` (so the shared split-table keys contain it), then on a second
instance insert `MyStr("attr1")` (a str subclass) into its `__dict__`. The key exists in the shared keys but
has no value in this dict yet.

Clean: prints `['attr1'] MyStr {'attr1': 2}`, exit 0.
Buggy: insertdict() checks `ix == DKIX_EMPTY` instead of `old_value == NULL`, so it calls replace_value
with a NULL old value and aborts with `Assertion 'old_value != NULL' failed` (exit -6).
