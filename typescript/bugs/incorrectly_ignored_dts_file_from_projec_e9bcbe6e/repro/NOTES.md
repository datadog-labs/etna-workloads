Project `consumer` references composite project `producer`, whose `in-js.d.ts` (a root .d.ts file) imports `@common` through the producer's `paths` mapping; run with `tsc -b consumer`.
Clean: `@common` resolves via the project reference, no errors, exit 0.
Injected: root .d.ts files of referenced projects are skipped, so `@common` is unresolved (TS2307 in producer/in-js.d.ts) and `n` is implicitly any (TS7006); exit 2.
