Input: a single in-memory target.ts (`const k = 1; console.log(k); ...`); the language service's getPasteEdits pastes a copy of `console.log(k);` from the same file into another location.
Clean: no edits are returned (`k` is a local of the same file, so no import is needed).
Injected: the file-identity check in getExistingLocals fails against the temporarily updated file, so the result contains bogus edits: `export ` added to `const k`, plus `import { k } from "./target";`.
