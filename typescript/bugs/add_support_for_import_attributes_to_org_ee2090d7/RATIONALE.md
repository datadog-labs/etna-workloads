# Rationale
One hunk in `tree/src/services/organizeImports.ts`, `coalesceImportsWorker`: corresponds to the fix's main hunk, which grouped imports by their `with`/`assert` attributes before coalescing. I replaced the attribute-derived grouping key with a constant (`groupBy(importGroup, () => "")`). Imports from the same module with different attributes are therefore merged into one declaration again, and attributes are lost or wrongly applied, which is the bug in issue 57215.

Final check.sh: SUMMARY: 4/4 oracle cases failing (4 fix-added).
