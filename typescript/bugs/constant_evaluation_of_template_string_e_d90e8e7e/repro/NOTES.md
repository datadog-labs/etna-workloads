`input.ts` has `const d = `${b} 3` as const` where `b` is a const string built by constant concatenation (`'1' + ' 2'`), then assigns `d` to type `"1 2 3"`.
Clean: the template is constant-evaluated to `"1 2 3"`, so there is no error.
Injected: the const-context check runs first and gives `${string} 3`, so tsc reports TS2322 (not assignable to `"1 2 3"`).
