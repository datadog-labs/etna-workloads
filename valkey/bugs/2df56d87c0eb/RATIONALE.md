# Rationale

## Changed: src/cluster_legacy.c, clusterUpdateSlotsConfigWith
Removed `delete_dirty_slots = 1;` (and its comment) from the "I am now an empty primary" branch.
This reverses the fix hunk that added `delete_dirty_slots = 1` there. The `delete_dirty_slots` variable and the
`if (delete_dirty_slots)` block stay (the fix's other hunks); only the empty-primary path no longer sets it, which
matches the pre-fix behaviour where only the `else if (dirty_slots_count)` branch deleted dirty slots.
The `delKeysInSlot` hunk (kvstoreDictSize -> countKeysInSlot) is a no-op refactor in 9.0.7 (it already uses countKeysInSlot), so it is not reverted.

## Oracle failures
"Empty primary will check and delete the dirty slots" fails: the node logs "I am now an empty primary" but never
logs "Deleting keys in dirty slot 0", so the dirty key is left behind. The other 8 cases pass.
