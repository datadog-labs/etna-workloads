# Rationale
One hunk, tree/src/compiler/utilities.ts `filterOwnedJSDocTags`. It matches the fix.diff hunk that changed
`filterOwnedJSDocTags` so that earlier (non-last) JSDoc comments still contribute their `@overload` tags.
Reverted behaviour: only the last JSDoc comment contributes; earlier ones contribute nothing, so overloads
declared in earlier JSDoc blocks (e.g. functions assigned to a prototype) are lost.

SUMMARY: 4/18 oracle cases failing (4 fix-added).
