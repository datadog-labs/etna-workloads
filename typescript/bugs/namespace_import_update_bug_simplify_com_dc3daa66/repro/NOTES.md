Uses the language service "Move to a new file" refactor on `export const x` in /a.ts, while /x.ts does `import * as a from "./a"; a.x;`.
The new file is named `x.2.ts` (since x.ts and x.1.ts exist).
Clean: the added import uses a valid identifier derived from the name (`import * as x2 from "./x.2"`).
Injected: it uses the base file name, giving the invalid identifier `x.2`.
