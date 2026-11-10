# Rationale
Single hunk in tree/src/compiler/parser.ts, corresponding to both hunks of fix.diff: the new `parseJSDocLinkName` helper is removed and its call site in the JSDoc link parser is replaced by the pre-fix inline code (`parseEntityName(true)` plus the private-identifier loop). `parseEntityName` reports TS1003 when a `.` is followed by a `#private` name, which is the bug.

Final: SUMMARY: 1/6 oracle cases failing (1 fix-added).
