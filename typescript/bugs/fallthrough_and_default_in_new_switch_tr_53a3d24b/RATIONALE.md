# Rationale
Single hunk in tree/src/compiler/checker.ts (narrowTypeBySwitchOnTrue call in the switch-clause flow narrowing, corresponds to both fix.diff hunks):
- Call site hunk: restored the pre-fix inline logic that narrows only by the first clause's expression (`clauseStart`), ignoring fallthrough sets (clauseEnd) and default clauses.
- Helper hunk: removed `narrowTypeBySwitchOnTrue` (added by the fix; would otherwise be unused and fail the build). It handled narrowing away previous cases, default, and unions across fallthrough clauses.

Final: SUMMARY: 11/60 oracle cases failing (11 fix-added).
