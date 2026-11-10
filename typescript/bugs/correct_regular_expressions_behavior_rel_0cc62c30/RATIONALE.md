# Rationale
One hunk, scanner.ts (decimal escapes check at end of scanRegularExpressionWorker): corresponds to the last fix.diff hunk.
Fix removed `!annexB &&` guard so that backreferences beyond the group count are always reported. Re-injected as `anyUnicodeModeOrNonAnnexB && escape.value > numberOfCapturingGroups` (today's equivalent of the old `!annexB` after annexB was forced false in unicode mode), so non-unicode Annex B regexes like /\1/ silently skip the error.
Final: SUMMARY: 3/24 oracle cases failing (0 fix-added).
