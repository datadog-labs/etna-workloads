Input declares two recursive tuple aliases T1<T> and T2<T> (same shape) and assigns between them in a generic function.
Clean: only the expected TS2322 on `y = x`.
Injected: additionally reports spurious TS2321 "Excessive stack depth comparing types 'T2<U>' and 'T1<U>'" on `x = y` (tuple recursion identity is wrong).
