One hunk, checker.ts (serializeSymbolWorker): removed `| SymbolFlags.Accessor` from the flag mask guarding serializeVariableOrProperty. This is the exact reverse of the fix's single hunk; accessor-only symbols from JS are no longer serialized into the declaration output, so getters go missing.
Final: SUMMARY: 1/6 oracle cases failing (1 fix-added).
