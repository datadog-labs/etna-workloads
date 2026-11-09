Input: in-memory project where /bar.ts imports `y` from ./a, and the language service runs "Move to file" on /a.ts's `export const y` with target /bar.ts.
Clean: bar.ts's import is removed and no self-import is added.
Injected: bar.ts also gets a self-import `import { y } from "./bar"` inserted.
