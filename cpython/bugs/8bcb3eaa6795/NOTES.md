repro.py installs a lazy-imports filter that prints the `fromlist` it receives, then calls
`__lazy_import__("json", fromlist="dumps")` with a str fromlist.
Clean: the filter sees the normalized tuple `('dumps',)`.
Buggy: the filter sees the raw str `'dumps'` (injection passes orig_fromlist instead of the packed tuple).
