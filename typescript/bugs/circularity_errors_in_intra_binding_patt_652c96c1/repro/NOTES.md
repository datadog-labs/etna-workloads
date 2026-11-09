`input.ts` has destructuring declarations where a default initializer references an earlier sibling binding (`const [c1, c2 = c1] = [123]`, `const { e1, e2 = e1 } = { e1: 1 }`).
Clean tsc under `--strict` reports no errors.
Injected tsc reports spurious TS7022 ("implicitly has type 'any' because ... referenced in its own initializer") on `c1` and `e1`.
