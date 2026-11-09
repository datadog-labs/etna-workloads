Input calls `admins.filter(isDefined)` with `isDefined<T>(a: T | undefined): a is T` and `admins: ("admin" | undefined)[]`. It then assigns the result to `string[]`.
Clean: `T` is inferred as `"admin"`, because the type predicate keeps the literal from being widened. `foundAdmins` is `"admin"[]`, so there is no error (exit 0).
Injected: the predicate is ignored when deciding on widening, so the inferred type is wrong and tsc reports TS2322 (`("admin" | undefined)[]` is not assignable to `string[]`), exit 2.
