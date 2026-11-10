Input calls `.f((e) => e)` on a union `Err<0> | Err<1> | Ok<2>`, where only some members have a generic signature (mixed type parameter presence).
repro.sh uses the API to print the type of `e2`.
Clean: `Err<2> | Err<0 | 1 | 2>`. Injected: `Err<U> | Err<2> | Err<0 | 1 | 2>`, because the type parameter U leaks.
