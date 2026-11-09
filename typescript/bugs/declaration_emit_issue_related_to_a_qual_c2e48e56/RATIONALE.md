# Rationale
One hunk, in `tree/src/compiler/expressionToTypeNode.ts` (the import-type case in `visitExistingNodeTreeSymbols`). The code that fix.diff changed in `checker.ts` has since moved to this file.

It corresponds to the fix.diff hunk `@@ -8823` (updateImportTypeNode). I changed `visitNode(node.attributes, ...)` and `visitNode(node.qualifier, ...)` back to `node.attributes` and `node.qualifier`. The original nodes are now reused as-is instead of being visited and cloned. A qualifier from another file therefore keeps its original positions, which brings back the cross-file declaration emit bug.

I did not re-introduce the other fix.diff hunks. They are the questionToken, modifiers, parameterName and jsdoc name changes. The one hunk already makes the fix-added test fail.

Final check.sh summary: `SUMMARY: 1/6 oracle cases failing (1 fix-added).`
