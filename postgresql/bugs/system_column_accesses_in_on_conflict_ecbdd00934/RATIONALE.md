# Rationale

File: src/backend/executor/nodeModifyTable.c, function ExecInitModifyTable (ON CONFLICT DO UPDATE setup).
Traces to the single fix.patch hunk: the oc_ProjSlot creation. The fix made the UPDATE SET projection
slot a table-type slot (so system attributes can be read by RETURNING). Reverted: the slot is again a
virtual slot (ExecInitExtraTupleSlot with TTSOpsVirtual, using the relation's tuple descriptor), which has no
system attribute support, so ON CONFLICT DO UPDATE ... RETURNING <system column> (e.g. tableoid, ctid) fails/misbehaves.

Oracle case expected to fail: src/test/regress||update
