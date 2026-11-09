# Rationale
Changes in `src/compiler/sys.ts` (createSystemWatchFunctions):
1. Fix hunk "`(!fsWatchWithTimestamp ? fsWatchWorker : fsWatchWorkerHandlingTimestamp)(`" -> reverted: the present-entry watcher now always calls plain `fsWatchWorker(` (today's code also had a Directory condition).
2. Fix hunk adding `fsWatchWorkerHandlingTimestamp` -> removed the function (would otherwise be unused).
The `fsWatchWithTimestamp` plumbing is kept: today's code also uses it in createUseFsEventsOnParentDirectoryWatchFile, a later addition outside this fix's hunks.
Effect: access-time-only "change" events on macOS are no longer filtered, so they trigger spurious rebuilds.

SUMMARY: 1/29 oracle cases failing (1 fix-added).
