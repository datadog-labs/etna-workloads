# Rationale

Fix 2e9fb129 stopped a stale `Mem.eSubtype` from surviving when a register is
overwritten, by making the subtype a flag (`MEM_Subtype`) that is cleared whenever
the type flags are reassigned. In 3.54.1 that machinery exists, so the fix cannot
be reversed hunk by hunk. I re-expressed the pre-fix behaviour: the subtype
survives overwrites.

1. `src/vdbeInt.h`: `MEM_TypeMask` no longer contains `MEM_Subtype`
   (0x0dbf -> 0x05bf). This reverses the fix's `MEM_TypeMask` hunk.
   `MemSetTypeFlag()` no longer clears the subtype.

2. `src/vdbe.c`, `OP_Column`: saves `MEM_Subtype` from the destination register
   after the dynamic-content reset and ORs it back at `op_column_out`. Before the
   fix, `OP_Column` wrote the new value and left the old `eSubtype` in place. In 3.54.1
   `OP_Column` assigns `pDest->flags` directly, so this restores the old effect.
   It is the path that matters for the fix's test.

The fix's `utf.c`, `vdbeapi.c` and `memTracePrint` hunks are not reverted. They
implement the flag representation, which still exists.

## Oracle failure
`json103-300` fails. `json_group_array(x)` over `1,'abc'` returns `[1,abc]`
instead of `[1,"abc"]`. In the VDBE program, r[4] holds the JSON subtype left by
`json_object()` from the previous row and is then overwritten by `OP_Column`.
`json_group_array()` takes the stale subtype to mean the value is already JSON.
All other oracle cases pass.
