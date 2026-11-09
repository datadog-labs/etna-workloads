Input declares `const res1 = fn1(() => res1)` and `const res3 = fn3()(() => res3)` (generic calls whose callback refers to the variable being initialized), compiled with `tsc --strict --noEmit`.
Clean: reports TS7022 on res1 and TS7024 on the arrow function; nothing on res3.
Injected: skips TS7024 and reports a spurious TS7022 on res3 (call resolution stack not reset, so the circularity is attributed differently).
