Input calls a generic `f<T extends any[]>(v: ReadonlyArray<T>)` with an array of tuples-like arrays containing `undefined`/`1` and arrow functions, under `strict`.
Clean: no diagnostics, exit 0.
Injected: spurious TS7024 (implicit any return type) on both arrow functions, exit 2, because composite signatures are not checked for return-type resolution cycles.
