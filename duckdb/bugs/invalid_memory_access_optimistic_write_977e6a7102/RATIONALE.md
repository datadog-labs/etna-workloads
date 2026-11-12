# Rationale

Today's code differs from the fix's parent: pinning is centralised in `CollectionScanState::SetRowGroup`
(`pinned_row_group = row_group->ReferenceNode()`), and the member already exists in scan_state.hpp.
The fix's pinning is re-expressed by removing it and going back to dereferencing the tree node directly.

File: src/storage/table/scan_state.cpp
- `SetRowGroup`: removed the `pinned_row_group = ...` assignment (fix hunks adding `state.pinned_row_group = node.ReferenceNode()` / resets to nullptr). The scan no longer owns the RowGroup.
- `CollectionScanState::Scan(ScanOptions...)`, `Scan(DataChunk&, TableScanType...)`, `PrepareScanIO`, `RegisterAssignmentIO`, `InitializeColumnScans`, `ProcessPreparedScan`: `pinned_row_group->X` / `*pinned_row_group` replaced by `row_group->GetNode().X` (reverses the fix's changes in scan_state.cpp). If an optimistic flush swaps the segment payload mid-scan, the scan uses freed memory.
- The header member `pinned_row_group` is left (now unused); the row_group.cpp `PrepareScan` hunk already matches the pre-fix form no longer needed.

## Oracle result
```
FAIL     test/sql/storage/optimistic_write/optimistic_write_cyclic_scan_single_thread.test
         ... SIGABRT - Abort (abnormal termination) signal
1 of 1 oracle units fail
```
