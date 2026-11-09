# Rationale
One hunk, `tree/src/compiler/transformers/module/module.ts`, `visitIfStatement`: the then/else statements are visited with `visitor` instead of `topLevelNestedVisitor`. This corresponds to the fix.diff hunk that added `visitIfStatement` (and the `IfStatement` case in `topLevelNestedVisitor`) so that `var` declarations nested in a top-level `if` get their exports handled (hoisting). Without it, exported vars inside `if` are not rewritten, as before the fix.

Final: SUMMARY: 2/12 oracle cases failing (1 fix-added).
