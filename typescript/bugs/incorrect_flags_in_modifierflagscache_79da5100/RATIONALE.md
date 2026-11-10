# Rationale
One hunk, in `tree/src/compiler/utilities.ts`, in `getModifierFlagsWorker`. It corresponds to the fix's hunk that changed the same function.
The last line of the function now calls `selectEffectiveModifierFlags(node.modifierFlagsCache)` instead of `selectSyntacticModifierFlags(...)`.
Once the JSDoc flags have been cached, a syntactic-only query returns them as well. This is the bug the fix removed: syntactic and effective flags were mixed in the cache.
The test "get syntactic and effective modifiers caches and reports correct flags in JS file" now fails (`expected +0 to equal 2`).
The fix's other hunks (the `ModifierFlags` enum reordering and the `fixSpelling` change) are not reverted, because the bug lives in the worker.

Final summary: SUMMARY: 1/31 oracle cases failing (0 fix-added).
