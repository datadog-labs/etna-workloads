repro.go: stores two uint16 fields from `x` and `x>>8` (shift gap 8, field size 16 bits).
The injected store-combining check compares shifts against i*8 instead of
(offset diff)*8, so the buggy compiler wrongly merges them into one 32-bit
little-endian store of x. Clean prints `3344 2233`; buggy prints `3344 1122`.
