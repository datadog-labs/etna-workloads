Input: a.ts defines `function foo(){}` and calls `foo()`; the script asks the language service (`getPasteEdits`) to paste the selected `foo()` into an empty `folder/target.ts`. Files are in memory, and the host supplies `runWithTemporaryFileUpdate`.
Clean: returns edits that export `foo` in a.ts and add `import { foo } from "../a"` plus the pasted text in the target.
Injected: the selection's edge identifier isn't counted as selected, so `edits` is `[]`.
