Destructures `[string, ...string[]]` into `[s0, s1]` under `noUncheckedIndexedAccess`.
Clean: `s1` is `string | undefined`, so `s1.toUpperCase()` reports TS18048 (printed).
Injected: `s1` is `string`, no error.
