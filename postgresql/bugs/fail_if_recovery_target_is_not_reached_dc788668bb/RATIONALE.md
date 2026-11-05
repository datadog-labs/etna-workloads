# Rationale

Hunk: src/backend/access/transam/xlogrecovery.c, PerformWalRecovery().
Traces to the fix_impl.patch hunk in xlog.c StartupXLOG that added the check
`ArchiveRecoveryRequested && recoveryTarget != RECOVERY_TARGET_UNSET && !reachedRecoveryTarget` -> FATAL
("recovery ended before configured recovery target was reached"). In current code that logic lives
at the end of PerformWalRecovery(); I removed it. (The variable rename in the patch is cosmetic.)
Without the check, recovery that ends before reaching the configured target silently finishes and promotes.

Failing oracle case:
- src/test/recovery|t/003_recovery_targets.pl|recovery end before target reached is a fatal error
