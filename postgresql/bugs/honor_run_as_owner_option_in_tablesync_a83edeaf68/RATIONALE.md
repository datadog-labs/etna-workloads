# Rationale

File: src/backend/replication/logical/tablesync.c, function LogicalRepSyncTableStart.

Both hunks trace to fix.patch's changes in this same function. The fix added `SwitchToUntrustedUser(relowner)` before the initial COPY, guarded by `!run_as_owner`. It also added `RestoreUserContext` after the copy.
- I removed the `run_as_owner = MySubscription->runasowner; if (!run_as_owner) SwitchToUntrustedUser(...)` block. This is the fix's "Make sure that the copy command runs as the table owner" hunk. The ACL and RLS checks that follow now run as the subscription owner, and so does the COPY.
- I removed the `if (!run_as_owner) RestoreUserContext(&ucxt);` after the copy. This is the fix's matching restore hunk.

I left the `ucxt` and `run_as_owner` declarations and the include in place. Only the logic was reverted.

Failing oracle case: `table owner can do the initial data copy`.
