# Rationale
One hunk, in `src/compiler/binder.ts` `getContainerFlags`: removed the `case SyntaxKind.JSDocImportTag` block (the fix's only hunk added it). In today's code it had `PropagatesThisKeyword` added, but is otherwise the same container case. Without it, JSDoc @import tags are no longer containers, so import bindings are scoped to the enclosing host and report spurious "'X' is declared but its value is never read" (importTag24/25 errors baselines fail).

Final: SUMMARY: 2/12 oracle cases failing (2 fix-added).
