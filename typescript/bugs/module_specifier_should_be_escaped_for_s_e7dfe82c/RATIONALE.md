# Rationale
Hunk: tree/src/services/completions.ts, getInsertTextAndReplacementSpanForImportCompletion.
Fix hunk: wrapped the module specifier in escapeSnippetText. In today's code the escape wraps quote(...); I removed it, so `$`/`}`/`\` in the specifier are no longer escaped in snippet insert text (same faulty behaviour).

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
