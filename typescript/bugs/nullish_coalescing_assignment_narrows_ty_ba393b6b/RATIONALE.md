# Rationale
Single hunk in `tree/src/compiler/checker.ts` (`narrowType`, ~line 30168): removed `|| operatorToken.kind === QuestionQuestionEqualsToken` from the synthetic-optionality check. This reverses the sole hunk of fix.diff, so `a ??= b` left operand is no longer narrowed via narrowTypeByOptionality (bug 51760).

Final: SUMMARY: 4/12 oracle cases failing (4 fix-added).
