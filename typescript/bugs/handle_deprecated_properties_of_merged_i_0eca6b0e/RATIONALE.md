# Rationale
One hunk in `tree/src/compiler/checker.ts`, `isDeprecatedSymbol`. The fix added a special case: for a symbol with several declarations whose parent is an interface, the symbol is deprecated if *some* declaration is deprecated. In today's code that case is the ternary `parentSymbol.flags & SymbolFlags.Interface ? some(...) : every(...)`. I replaced it with plain `every(symbol.declarations, isDeprecatedDeclaration)`. A property of a merged interface is then deprecated only if all of its declarations are, which is the original bug.

Final ./check.sh summary: SUMMARY: 1/1 oracle cases failing (1 fix-added).
