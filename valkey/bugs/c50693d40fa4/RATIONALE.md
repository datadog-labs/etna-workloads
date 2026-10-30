# Rationale

Bug: SORT ... BY nosort on a list did not retain the list's native order (fix: "zero-ordering SORT against lists").

Changes in `tree/src/sort.c` (all in `sortCommand`):

1. Forced-sort condition now also covers lists (`OBJ_SET || OBJ_LIST`) with STORE/script. Reverses the fix's rule that only sets are forced to sort and other types keep native order. A list `BY nosort ... STORE` is then ALPHA-sorted instead of kept in list order.
2. Removed the `OBJ_LIST && dontsort` direct-load branch, which honoured DESC and LIMIT in native order. Lists now always go through the generic load branch. Also dropped `OBJ_LIST` from the "shrink vectorlen for LIMIT" optimisation, since that only works with the direct-load branch.

Oracle cases failing (tests/unit/sort.tcl):
- "SORT by nosort plus store retains native order for lists": got `1 2 3 4 5`, expected `5 3 4 1 2`.
- "SORT by nosort with limit returns based on original list order": got `1 2 3`, expected `5 3 4`.
