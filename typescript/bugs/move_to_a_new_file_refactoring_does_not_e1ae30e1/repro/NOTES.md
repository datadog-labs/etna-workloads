b.ts has `import type { A } from "./a"` and a function using A; the language service's "Move to a new file" refactoring is applied to the function.
Clean: the new file keeps `import type { A } from "./a";`.
Injected: the type-only status is lost and the new file gets a plain `import { A } from "./a";`.
