# Rationale
Hunk 1 (textChanges.ts, getTextChangesFromChanges): fix computed `targetSourceFile` from the original node's source file (Move to file, nodes come from another file). Re-injected as `const targetSourceFile = sourceFile;`, so formatting/indent use the wrong file's text/variant -> formatter crash/garbled output.
Hunk 2: removed the now-unused imports getOriginalNode/getSourceFileOfNode (fix added them).
The other fix hunks (signature threading) are left in place; with targetSourceFile == sourceFile they behave as before the fix.

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
