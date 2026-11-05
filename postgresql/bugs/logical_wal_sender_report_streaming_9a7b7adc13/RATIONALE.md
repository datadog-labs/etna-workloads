# Rationale

File: src/backend/replication/walsender.c, function XLogSendLogical().

Traces to the fix.patch hunk that added, after LogicalDecodingProcessRecord(), a check that sets
WalSndCaughtUp = true once the sent record reaches the flush pointer. In current code this is the
cached static flushPtr logic (initialize/refresh flushPtr, then
`if (EndRecPtr >= flushPtr) WalSndCaughtUp = true`). I removed that logic and the static flushPtr.
WalSndCaughtUp is then only set in WalSndWaitForWal, so the logical walsender stays in
CATCHUP state rather than reporting STREAMING when it has caught up without waiting.
This hunk also never sets the "streaming" state in the case the fix addressed.

Failing oracle cases: 12/38 in src/test/subscription t/001_rep_changes.pl
(e.g. "empty transaction is skipped"; see the oracle output for the full list).
