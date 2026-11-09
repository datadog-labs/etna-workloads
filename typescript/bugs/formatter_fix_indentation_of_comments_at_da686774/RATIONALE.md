# Rationale
Single hunk in tree/src/services/formatting/formatting.ts (formatSpanWorker), corresponding to the only hunk of fix.diff.
Restored the pre-fix logic: `if (!formattingScanner.isOnToken())` guard, with leading trivia indented using indentNextTokenOrTrivia=false and without the insertIndentation call per trivia item. Comments at the end of a formatted range are therefore not indented (e.g. `// test comment` left at column 0).

Final check.sh: SUMMARY: 6/6 oracle cases failing (6 fix-added).
