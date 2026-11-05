# Rationale

File: src/src/backend/commands/tablecmds.c

- `CloneFkReferencing`: the synthetic `Constraint` node is again built with the
  old, sparse initialization (no contype/location/pktable/etc., traces to the
  second hunk of fix_impl.patch) and, crucially, `initially_valid` is no longer
  set. It stays false (makeNode zeroes it), so FKs created in a partition by
  ATTACH PARTITION are marked NOT VALID.
- `CloneFkReferenced`: reverted to the sparse initialization (first hunk of
  fix_impl.patch). It has no functional effect.
- The `DetachPartitionFinalize` hunk was not touched. The fix only made the
  initialization more complete there and had no functional effect.

Failing oracle case: src/test/regress||foreign_key
