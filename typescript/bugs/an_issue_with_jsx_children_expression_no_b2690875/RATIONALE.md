# Rationale
Single hunk in `getContextualTypeForChildJsxExpression` (checker.ts), matching the only hunk of fix.diff:
the contextual type is again taken from `node.openingElement.tagName` rather than `.attributes`, so JSX child
expressions aren't contextually discriminated by the attributes. A `as Expression` cast was needed because
`JsxTagNameExpression` now includes `JsxNamespacedName`, so it wouldn't type-check otherwise (no runtime effect).

Final: SUMMARY: 2/6 oracle cases failing (2 fix-added).
