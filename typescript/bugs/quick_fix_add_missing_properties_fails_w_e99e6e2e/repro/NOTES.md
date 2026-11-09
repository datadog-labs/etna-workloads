Input: E.ts exports `enum E {A, B}`; foo.ts imports it and writes `const t: T = { }` where T requires `e: E`.
The script asks the language service for the "Add missing properties" code fix and prints the inserted text.
Clean: `{ e: E.A }` (enum symbol used). Injected: uses the enum member's parent (module symbol) so the text is wrong (e.g. `"E".A`/module-qualified name).
