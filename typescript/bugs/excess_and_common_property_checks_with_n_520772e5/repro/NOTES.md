Calls a generic function whose parameter is `NoInfer<T> | (() => NoInfer<T>)` with object literals.
Clean: only the real excess property `y` is reported (TS2353 on line 7).
Injected: the union with NoInfer (substitution type) isn't handled in excess-property checks, so it
wrongly reports `x` as unknown in type `() => NoInfer<...>` on both calls (including the valid one).
