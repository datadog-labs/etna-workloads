# Rationale
Single hunk in `tree/src/compiler/expressionToTypeNode.ts` (computed property name handling in `visitExistingNodeTreeSymbolsWorker`). The checker.ts code the fix touched has since moved here. Fix.diff's hunk replaced `Debug.assertNode(type, isLiteralTypeNode)` with a fallback (evaluate the enum entity name, or return the node and track the computed name). I restored the assert and `const literal = computedPropertyNameType.literal;`, removing the fallback. Non-literal types (enum members, unique symbols) crash declaration emit with a Debug Failure again.

Final: SUMMARY: 18/30 oracle cases failing (18 fix-added).
