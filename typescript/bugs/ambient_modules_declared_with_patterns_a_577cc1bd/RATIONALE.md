# Rationale
Hunk: tree/src/services/stringCompletions.ts, getAmbientModuleCompletions: removed the `!moduleName.includes("*")` filter (today's form of the fix's `moduleName.indexOf("*") < 0`). Pattern ambient modules (e.g. "foo*") are again offered in path completions.

Summary: SUMMARY: 1/1 oracle cases failing (1 fix-added).
