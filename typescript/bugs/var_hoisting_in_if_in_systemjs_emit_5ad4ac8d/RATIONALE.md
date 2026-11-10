# Rationale
All hunks in tree/src/compiler/transformers/module/system.ts, mirroring fix.diff:
- Removed `case SyntaxKind.IfStatement` in topLevelNestedVisitor (fix hunk 2).
- Removed `visitIfStatement` function (fix hunk 3), so `var` in if/else bodies is no longer hoisted via topLevelNestedVisitor in SystemJS emit.
- Removed now-unused `IfStatement` import (fix hunk 1).

Result: `SUMMARY: 1/6 oracle cases failing (1 fix-added).` (topLevelVarHoistingSystem JS output baseline)
