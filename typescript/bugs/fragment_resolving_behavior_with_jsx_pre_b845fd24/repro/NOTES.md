input.tsx uses an empty JSX fragment `<></>` with tsconfig `jsx: react`, `jsxFactory: h`, `jsxFragmentFactory: "null"`.
Clean: no errors (null fragment factory is allowed, exit 0).
Injected: reports TS2879 "Using JSX fragments requires fragment factory 'null' to be in scope" (exit 2).
