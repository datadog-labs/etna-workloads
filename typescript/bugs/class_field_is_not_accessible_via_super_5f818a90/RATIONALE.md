# Rationale
One hunk, tree/src/compiler/checker.ts (checkPropertyAccessibilityAtLocation): removed the block
rejecting `super.x` for non-static class fields (error 2855). Corresponds to the fix's checker.ts hunk
adding that check (today's code uses `isClassInstanceProperty` instead of `isClassFieldAndNotAutoAccessor`).
Without it, super access to a parent's class field is silently allowed again.
The other fix hunks (diagnostic message, helper) are definitions only; left in place.

Final: SUMMARY: 2/18 oracle cases failing (1 fix-added).
