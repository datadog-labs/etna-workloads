Hunks (all three revert the fix):
- checker.ts overrideHost lookup: drops isJSDocImportTag(l), so resolution-mode override in @import tags is ignored in the checker (fix hunk 1).
- program.ts getModeForUsageLocationWorker: drops isJSDocImportTag(usage.parent), so @import attributes aren't used for module mode (fix hunk 2).
- utilities.ts hasResolutionModeOverride: param type loses JSDocImportTag (fix hunk 3).
Result: SUMMARY: 2/6 oracle cases failing (2 fix-added).
