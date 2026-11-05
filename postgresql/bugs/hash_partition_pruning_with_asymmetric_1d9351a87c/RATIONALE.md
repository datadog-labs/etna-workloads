# Rationale
Both hunks are in src/src/backend/partitioning/partprune.c and trace to the partprune.c hunks of fix.patch. The fix made pruning use boundinfo->nindexes, the length of indexes[]. These edits go back to ndatums, which is wrong when a hash partition set is asymmetric (ndatums < greatest modulus).

1. get_matching_hash_bounds, the "no keys" else branch: the bound_offsets range is 0..ndatums-1 instead of 0..nindexes-1. This is the fix.patch hunk at "Report all valid offsets into the boundinfo->indexes array". It drops the high indexes[] slots, so partitions can be wrongly pruned.
2. perform_pruning_combine_step, the empty source_stepids case: bms_add_range uses ndatums-1 instead of nindexes-1. This is the fix.patch hunk that replaced rangemax. It has the same effect for hash partitioning.

Failing oracle case: src/test/regress||partition_prune (expected; I did not read its result).
