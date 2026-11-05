# Rationale

The fix's hunks were written against the old code in `catalog/partition.c`. That code is now `partitioning/partbounds.c`, and it has been rewritten, so I re-expressed only the "which partition does the new one overlap with" part of the fix.

## Changed hunk
- File and function: `src/backend/partitioning/partbounds.c`, `check_new_partition_bound()`, RANGE case, branch where the new lower bound is in a gap but the new upper bound crosses the next partition's lower bound.
- Traces to: the `fix.patch` hunk that replaced `with = boundinfo->indexes[off2 + 1]` with a choice between `indexes[off2]` and `indexes[off2 + 1]`. The old code used the wrong index there and could end up with `with = -1`.
- Change: `with = boundinfo->indexes[offset + 2]` is now `indexes[offset + 1]`.
- Why this brings the bug back: `offset + 1` is the lower bound of the next partition, and its index is -1. So `with` is -1 instead of the overlapped partition. That trips `Assert(with >= 0)` and indexes `partdesc->oids[-1]` when building the error message, so the "would overlap" error is wrong or crashes.

## Not reverted
The fix's `if (*is_equal) break;` in `partition_bound_bsearch` has no effect on results in the current code. The current `partition_range_bsearch` returns the same answer with or without it, so removing it would not bring the bug back.

## Failing oracle cases
- src/test/regress||create_table
