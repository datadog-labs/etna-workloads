input.ts spreads a parenthesized array literal `...([1, 2])` into a call of a two-parameter function.
Clean: the literal is tupleized, so no errors (exit 0).
Injected: reports TS2556 "A spread argument must either have a tuple type or be passed to a rest parameter" (exit 2).
