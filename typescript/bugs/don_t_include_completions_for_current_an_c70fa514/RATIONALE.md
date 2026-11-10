# Rationale
Single file: tree/src/services/completions.ts, in `shouldIncludeSymbol` (today's equivalent of the fix's filter hunk in getCompletionEntriesFromSymbols).

Removed the block "Filter out current and latter parameters from defaults" (both the `isParameter` branch and the `isTypeParameterDeclaration` branch, incl. the self-recursive `K extends` case). This corresponds to the fix's hunk adding "Filter out parameters from their own initializers", which dropped parameters / type parameters at or after the current one from completions. Without it, current/later parameters (e.g. `T` in `class D<T extends |>`) are offered again.
The fix's helper-function hunks (getVariableOrParameterDeclaration, isArrowFunctionBody) already exist in a generalised form (getClosestSymbolDeclaration) and are left intact since they still serve the variable case.

Result: SUMMARY: 1/14 oracle cases failing (0 fix-added) — completionListInTypeParameterOfClassExpression1 fails at marker 4 (extra 'T').
