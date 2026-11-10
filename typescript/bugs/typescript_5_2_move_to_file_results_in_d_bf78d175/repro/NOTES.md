Input: /a.ts and /b.ts both import `x` from ./common; the language service "Move to file" refactor moves `bar` (uses x) from a.ts into b.ts.
Clean: b.ts's existing `x` import is reused, so no extra import edit is produced for b.ts.
Injected: the already-imported `x` is not recognised as an existing target local, so a duplicate `import { x } from "./common"` is added to b.ts.
