# Rationale
One hunk in tree/src/compiler/checker.ts (resolveDeclaredMembers late-binding assignments, ~line 13979).
Fix.diff changed `symbol.assignmentDeclarationMembers` into a lookup that, for arrow/function-expression
value declarations, uses the parent (variable) symbol's assignmentDeclarationMembers. Today's code does this via
helper `getFunctionExpressionParentSymbolOrSymbol(symbol)`; I reverted that call to plain `symbol.assignmentDeclarationMembers`,
so dynamic-name expando assignments on function expressions are no longer found.
Final: SUMMARY: 3/6 oracle cases failing (3 fix-added).
