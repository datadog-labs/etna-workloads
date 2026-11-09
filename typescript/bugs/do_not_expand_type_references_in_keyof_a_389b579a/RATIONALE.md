# Rationale
All hunks are in tree/src/compiler/expressionToTypeNode.ts (the code moved here from checker.ts).
1. Removed the `isIndexedAccessTypeNode` branch (fix: added indexed-access/tryVisitTypeReference branch) so indexed access types no longer get the reuse-or-error handling.
2. Type reference branch: on failure it calls `serializeExistingTypeNode` again (fix replaced it with hadError/markError), expanding the reference.
3. Removed the `keyof` branch in the TypeOperator case (fix added keyof handling via tryVisitTypeReference), so keyof T falls to generic visiting and references get expanded.

Final: SUMMARY: 3/43 oracle cases failing (2 fix-added).
