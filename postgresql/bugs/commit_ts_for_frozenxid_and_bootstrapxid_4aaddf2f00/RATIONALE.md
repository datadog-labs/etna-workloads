# Rationale

Hunk: src/backend/access/transam/commit_ts.c, `TransactionIdGetCommitTsData()`.
Traces to the single hunk of fix_impl.patch. The fix split the check: an invalid xid errors, while frozen and bootstrap xids return `false` with ts=0 and nodeid=0. I restored the old check, `if (!TransactionIdIsNormal(xid)) ereport(ERROR ...)`. Frozen and bootstrap xids now raise "cannot retrieve commit timestamp" instead of returning a null timestamp.

Failing oracle cases: the "getting ts of BootstrapTransactionId succeeds" and "getting ts of FrozenTransactionId succeeds" cases in 004_restart.pl (to be confirmed by the oracle run).

Confirmed failing oracle cases (3/17):
- src/test/modules/commit_ts|t/004_restart.pl|getting ts of BootstrapTransactionId succeeds
- src/test/modules/commit_ts|t/004_restart.pl|getting ts of FrozenTransactionId succeeds
- src/test/modules/commit_ts||commit_timestamp (the regression test)
