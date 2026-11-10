# Rationale
Single hunk in tree/src/services/refactors/extractType.ts: in getRangeToExtract, the enclosing node is again
`Debug.checkDefined(findAncestor(firstType, isStatement), "Should find a statement")`, and the `getEnclosingNode` helper
(statement || JSDoc fallback for JS) is removed. This corresponds to the fix's hunks in getRangeToExtract / the added getEnclosingNode.
Without a statement ancestor (type in a free-floating JSDoc) it asserts instead of using the JSDoc as the host.
(The JSDoc-insertion branch in doTypedefChange is left in place; it is unreachable without the fallback.)

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
