input.ts calls a type guard `isNotNull(x?.y?.z)` (x is NonNullable<A>) and in the true branch uses `x.y.z`.
Clean: no errors, since the guard narrows the optional chain's `x.y` to non-undefined.
Injected: error TS18048 "'x.y' is possibly 'undefined'" at the `x.y.z` argument of title(), exit 2.
