# Rationale

Changed file: src/backend/tcop/pquery.c (2 hunks), tracing to the pquery.c hunks of fix_impl.patch.

1. PortalRunUtility(): `PushActiveSnapshotWithLevel(snapshot, portal->createLevel)` reverted to `PushActiveSnapshot(snapshot)`.
2. EnsurePortalSnapshotExists(): same reversion.

Without the level, the snapshot is owned by the current (sub)transaction nesting level rather than the portal's creation level. When a subtransaction ends, the snapshot is popped while portal->portalSnapshot still points to it, leaving a dangling pointer.

The other fix hunks (createLevel field, AtSubCommit_Portals, the snapmgr function) are left in place. They are inert without these callers, so the change stays minimal.

Failing oracle case: src/pl/plpgsql/src||plpgsql_transaction
