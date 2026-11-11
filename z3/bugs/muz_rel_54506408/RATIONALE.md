# Rationale

Today's tree already has the refactor in FIX.diff (tbv_manager::set with bounds SASSERTs, private raw setters),
so the remaining bug is the off-by-one "overflow" in the udoc_relation.cpp hunks of FIX.diff, which changed
`d->pos().set(val, hi, lo)` to `set(d->pos(), val, hi-1, lo)` (column_idx(i+1) is one past the column's last bit).

1. udoc_relation.cpp fact2doc: FIX.diff hunk "@@ -49,7 +49,7" (hi -> hi-1). Reverted to pass `hi` (exclusive bound) as the inclusive upper bit, so it writes past the column.
2. udoc_relation.cpp filter_equal_fn ctor: FIX.diff hunk "@@ -637,7 +637,7" (same fix). Reverted to `hi`.

Result: bit range overflows into the next column / past num_tbits, tripping SASSERT(hi < num_tbits()) in tbv_manager::set.

Final ./check.sh:
PASS doc
PASS fixed_bit_vector
PASS tbv
FAIL udoc_relation (rc=110)
