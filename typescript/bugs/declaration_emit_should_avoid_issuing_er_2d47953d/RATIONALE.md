# Rationale
Hunk 1 (checker.ts, `getSymbolAccessibilityResult`/ resolve-entity fallback in `isEntityNameVisible`): fix.diff changed the
unresolved-name fallback result from `NotAccessible` to `NotResolved`. Reverted to `NotAccessible` (checker.ts ~line 6156).
Declaration emit then reports "private name" errors again on unresolved names (in addition to the checker's own error).
The transformer check (hunk 2) and enum member (hunk 3) are left in place; they become inert since NotResolved is never produced.

SUMMARY: 35/130 oracle cases failing (1 fix-added).
