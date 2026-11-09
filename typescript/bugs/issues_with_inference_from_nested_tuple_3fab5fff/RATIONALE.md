# Rationale
Single hunk in tree/src/compiler/checker.ts, getRecursionIdentity: for tuple types, return `type` instead of `type.target` (reverses the fix's hunk exactly). Nested tuples of the same shape then have distinct recursion identities, so inference from nested same-shape tuples is wrongly treated/limited as in the original bug.

Final check.sh: SUMMARY: 2/6 oracle cases failing (2 fix-added).
