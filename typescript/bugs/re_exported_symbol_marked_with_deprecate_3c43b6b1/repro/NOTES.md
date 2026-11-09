Input: `a.ts` exports `a`; `b.ts` re-exports it with `@deprecated`; `c.ts` re-exports from `b`; `d.ts` does `import * as _ from "./c"; _.a;`.
The script prints the language-service suggestion diagnostics for `d.ts`.
Clean: reports 6385 "'a' is deprecated." on `a`. Injected: no diagnostic, because the alias is not resolved before the deprecation check.
