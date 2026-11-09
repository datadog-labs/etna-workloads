`input.ts` assigns `a ??= true` to an optional boolean parameter, then compares `a === false`.
Clean: no error (a is still `boolean` after the assignment, since `a` was either non-nullish or assigned true).
Injected: `??=` no longer narrows the left operand by nullishness, so `a` becomes `true` and tsc reports TS2367 (no overlap) with exit 2.
