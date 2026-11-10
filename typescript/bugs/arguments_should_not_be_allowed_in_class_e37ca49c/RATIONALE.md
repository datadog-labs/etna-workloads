# Rationale
Changes in tree/src/compiler/checker.ts and diagnosticMessages.json, each reversing a fix.diff hunk:
1. checker.ts `checkIdentifier`: call `isInPropertyInitializerOrClassStaticBlock(node)` without `ignoreArrowFunctions`, and use the old diagnostic name (fix hunk 1). The same call in the typeof/`arguments` type path (the other call site) is also reverted.
2. checker.ts `isInPropertyInitializerOrClassStaticBlock`: restored the pre-fix body, which does not treat ClassStaticBlockDeclaration as a boundary. `arguments` directly in a static block is no longer reported (fix hunk 2).
3. diagnosticMessages.json: message text reverted to "'arguments' cannot be referenced in property initializers." (fix hunk 3).

SUMMARY: 4/18 oracle cases failing (0 fix-added).
