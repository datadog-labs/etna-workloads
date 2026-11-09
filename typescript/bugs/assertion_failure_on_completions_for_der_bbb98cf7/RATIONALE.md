# Rationale
One hunk, tree/src/services/completions.ts `getCompletionEntryDisplayNameForSymbol`, `CompletionKind.MemberLike` case:
reverted `return originIsComputedPropertyName(origin) ? {name: origin.symbolName, ...} : undefined` to `return undefined`.
Corresponds to the fix.diff hunk at "case CompletionKind.MemberLike" (the last completions.ts hunk). Without it, class-member completions for
a base property with a computed name (`[SOME_CONSTANT]`) get no display name and are dropped from the list (the bug's symptom area).
Other fix hunks (checker memberSymbol param) were already refactored so the assertion path no longer exists; not reverted.
Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
