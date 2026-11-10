Input declares two recursive tuple aliases of the same shape, `T1<T> = [number, T1<{x:T}>]` and `T2<T> = [42, T2<{x:T}>]`, then assigns between them in a generic function.
Clean: only the expected TS2322 error on `y = x` (number not assignable to 42).
Injected: additionally reports two spurious TS2321 "Excessive stack depth comparing types 'T2<U>' and 'T1<U>'" errors on `x = y`.
