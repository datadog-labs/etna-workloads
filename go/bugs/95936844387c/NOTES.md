`repro.go` uses a local `x` only inside `T{{x}}`, where `T` is undefined. The inner literal `{x}` has no type.

- clean: reports only `undefined: T` and `missing type in composite literal`. The checker continues with an invalid type, so `x` counts as used.
- buggy: the checker returns early, so `x` is never marked used. It also reports a spurious `declared and not used: x`.
