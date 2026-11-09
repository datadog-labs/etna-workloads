# Rationale
One hunk in `tree/src/compiler/checker.ts` (retained-node lookup in the node builder's entity-name visit, `const meaning = getMeaningOfEntityNameReference(node)`), now `const meaning = SymbolFlags.All`.
It corresponds to the fix.diff hunk at ~8576, which replaced `SymbolFlags.All` with the specific meaning in `resolveEntityName`, `isSymbolAccessible` and `trackSymbol`. In today's code the single `meaning` variable feeds all of those calls, so setting it to `SymbolFlags.All` restores the old behaviour: a retained annotation resolves to the wrong symbol (e.g. a value instead of a type), so the import is not retained in the declaration output.
The helper `getMeaningOfEntityNameReference` is kept because `isEntityNameVisible` uses it, as in the fix's other hunks.

Final check.sh: SUMMARY: 2/30 oracle cases failing (1 fix-added).
