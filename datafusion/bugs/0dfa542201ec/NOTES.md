repro.sql copies the issue #20437 regression test: a multi-key hash join where one build-side key is a Dictionary(Int32, Utf8) column.

- df-clean returns the two matching rows (exit 0).
- df-buggy panics (exit 101) in StructArray construction: "Incorrect array length for StructArray field c1, expected 3 got 2". `flatten_dictionary_array` returned the dictionary's unique values instead of the expanded column.
