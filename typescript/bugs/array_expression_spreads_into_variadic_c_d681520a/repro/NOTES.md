input.ts spreads an array literal (`...[2, 3]`) into a call with fixed (non-rest) parameters.
Clean: the literal is typed as a tuple, so the call type-checks with no errors (exit 0).
Injected: the literal is typed as number[], giving error TS2556 "A spread argument must either have a tuple type or be passed to a rest parameter" (exit 2).
