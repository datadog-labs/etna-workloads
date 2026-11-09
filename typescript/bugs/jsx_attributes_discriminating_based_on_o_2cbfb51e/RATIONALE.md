# Rationale
Single hunk in `discriminateContextualTypeByJSXAttributes` (tree/src/compiler/checker.ts), corresponding to the single hunk of fix.diff:
- Removed the `jsxChildrenPropertyName` const.
- Restored the old filter, which no longer skips the optional children property when the element has semantic JSX children.
  The missing optional `children` is then treated as `undefined` for discrimination, so a union member is wrongly discarded even though children were supplied.

Final check.sh: SUMMARY: 2/6 oracle cases failing (2 fix-added).
