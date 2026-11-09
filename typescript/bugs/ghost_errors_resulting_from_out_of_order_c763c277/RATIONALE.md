# Rationale
One hunk in `tree/src/compiler/checker.ts`, in `getResolvedSignature`. It corresponds to the last hunk of fix.diff, the one that added the `saveResolutionStart` / `resolutionStart = resolutionTargets.length` reset and the restore after `resolveSignature`.
I removed the save, the `if (!cached)` reset block, and the restore. Without the reset, an API client that asks for a symbol type inside a call argument sees the stale resolution stack. This produces the circularity "ghost errors" that the fix removed.
The other fix hunks (`??=` and the variances save/restore) are already absent or refactored in today's code, so they were not touched.

Final ./check.sh summary: SUMMARY: 7/21 oracle cases failing (3 fix-added).
