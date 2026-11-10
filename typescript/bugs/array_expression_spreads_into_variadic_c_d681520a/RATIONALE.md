Single hunk in tree/src/compiler/checker.ts (checkArrayLiteral): corresponds to the fix's hunk that added `isSpreadIntoCallOrNew || ...` to `inTupleContext`. Removed that term (and the now-unused helper isSpreadIntoCallOrNew), so array literals spread into calls/new are no longer typed as tuples again, restoring the variadic const call bug. (Today's code already lacked the inConstContext part of the fix.)

SUMMARY: 16/90 oracle cases failing (2 fix-added).
