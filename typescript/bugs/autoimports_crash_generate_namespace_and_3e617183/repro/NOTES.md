Input: b.ts does `import * as A from "./a"` and has a function using `A.ExecutionPoint`; the script asks the language service for the "Move to a new file" refactor on that function.
Clean: returns edits; the new file gets `import * as A from "./a";`.
Injected: getEditsForRefactor throws "Debug Failure. Expected exported symbol to have module symbol as parent" (namespace import is handled as an exported symbol).
