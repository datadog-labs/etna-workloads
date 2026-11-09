input.ts does `lhs instanceof rhs` where rhs has type `HasInstanceOf & object`, an intersection whose member declares `[Symbol.hasInstance]`.
Clean: no diagnostics. Injected: spurious TS2359 on the right-hand side of instanceof.
