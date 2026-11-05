# Rationale

Bug: commit 27cc7cd2bc8a fixed non-locking rowmark substitution tuples being stored in a slot
built with the wrong tuple descriptor (the old code used `EvalPlanQualSlot(relation=NULL)`, which
allocated a virtual slot with `origslot`'s descriptor), and fixed it by fetching non-locking
rowmarks lazily, in the scan, into the scan node's own slot.

## Hunk
- `src/include/executor/execScan.h`, `ExecScanFetch()` (rowmark branch). Traces to the fix.patch
  hunks in `EvalPlanQualSlot()` (the `relation == NULL` branch using
  `ExecAllocTableSlot(..., origslot->tts_tupleDescriptor, &TTSOpsVirtual)`) and
  `EvalPlanQualFetchRowMark()` (which fills the slot). The lazily fetched rowmark tuple is now
  stored in a virtual slot with the top-level row's descriptor instead of the scan slot, so
  the rowmark fetch (ExecStoreHeapTupleDatum / table_tuple_fetch_row_version) uses the wrong slot type/descriptor.

The whole-struct refactor (EState -> EPQState) is not reverted; only the wrong-descriptor slot is reintroduced.

## Failing oracle cases
- src/test/isolation||eval-plan-qual
