# Rationale
Hunk: tree/src/compiler/checker.ts, createJsxAttributesTypeFromAttributesProperty children handling: `getSemanticJsxChildren(parent.children).length > 0` -> `parent.children.length > 0`.
Corresponds to the single fix.diff hunk (reverse of it, in today's multi-line condition including fragments). Whitespace-only/empty-expression children again create a `children` prop.
Final: SUMMARY: 3/12 oracle cases failing (2 fix-added).
