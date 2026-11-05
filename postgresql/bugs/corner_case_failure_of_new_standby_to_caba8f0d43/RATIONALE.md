# Rationale
- File/function: src/backend/access/transam/xlogrecovery.c, WaitForWALToBecomeAvailable (streaming branch, when readFile < 0).
- Traces to the single xlog.c hunk in fix.patch (the code has since moved to xlogrecovery.c): `expectedTLEs = readTimeLineHistory(recoveryTargetTLI)` is reverted to `readTimeLineHistory(receiveTLI)`.
- Why it brings back the bug: with recovery_target_timeline='latest' and archiving, recoveryTargetTLI can advance after new history files are fetched from the archive. The history is then built from the older receiveTLI, so a new standby can't follow the new primary's timeline switch (stuck on the old timeline).

Failing oracle case:
- src/test/recovery|t/025_stuck_on_old_timeline.pl|check streamed content on cascade standby
