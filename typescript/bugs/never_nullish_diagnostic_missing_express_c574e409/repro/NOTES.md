input.ts has `a ?? 1 ?? 2`, where the inner `a ?? 1` is the left operand of an outer `??` and its right operand is the literal `1`.
The injected build adds a check on the right operand of a `??` nested in another `??`, so it reports "This expression is never nullish" on `1`.
The clean build reports nothing.
