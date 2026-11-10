Hunk: tree/src/compiler/checker.ts (~line 48693), removed `!importClause.isTypeOnly &&` from the condition that reports
"Importing a JSON file into an ECMAScript module requires a 'type: json' import attribute". This matches the single hunk of fix.diff
(today's condition uses Node18..NodeNext range instead of NodeNext only). Type-only JSON imports again wrongly require the attribute.
Final: SUMMARY: 3/24 oracle cases failing (0 fix-added).
