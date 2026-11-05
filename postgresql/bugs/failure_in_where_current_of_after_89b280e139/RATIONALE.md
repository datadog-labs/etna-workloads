# Rationale

Changed hunks (the fix's `pending_rescan` plumbing is left in place but made inert):

1. `src/backend/executor/execCurrent.c`, `search_plan_tree()`: removed the final
   `if (result && node->chgParam != NULL) *pending_rescan = true;`.
   Traces to the fix.patch hunk adding that block at the end of `search_plan_tree`.
   Without it, `execCurrentOf` never sees a pending rescan on the scan node or its ancestors, so it
   treats a scan with a pending rescan as still positioned on a row.

2. `src/backend/executor/execScan.c`, `ExecScanReScan()`: removed `ExecClearTuple(node->ss_ScanTupleSlot)`.
   Traces to the fix.patch hunk in execScan.c.
   A rescanned scan node keeps its stale tuple, so WHERE CURRENT OF after the cursor is rewound
   looks positioned and acts on the old row instead of returning false/no row.

Failing oracle case: `src/test/regress||portals`
