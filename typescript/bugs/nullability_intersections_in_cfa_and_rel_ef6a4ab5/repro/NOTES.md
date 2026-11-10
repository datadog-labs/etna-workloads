input.ts assigns `Partial<T>[K] & {}` and `Partial<T>[K] & ({} | null)` to `T[K]` under --strict.
Clean build: no errors (nullability intersection is normalized, so both are assignable).
Injected build: reports TS2322 on `t = p2` (`Partial<T>[K] & ({} | null)` not assignable to `T[K]`), exit 2.
