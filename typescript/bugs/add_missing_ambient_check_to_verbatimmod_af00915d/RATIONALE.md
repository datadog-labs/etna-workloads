# Rationale
Both hunks of fix.diff (checker.ts, checkExportAssignment) added `!(node.flags & NodeFlags.Ambient)` to the two verbatimModuleSyntax `export =` / `export default` error conditions (type-only alias branch and non-value branch). In today's code these are at the equivalent conditions (~lines 48899 and 48909); I removed that ambient check from both, so errors are again reported in ambient/declaration files.
(The third isolatedModules check at ~48919 was not part of the fix and is unchanged.)

Final: SUMMARY: 3/12 oracle cases failing (2 fix-added).
