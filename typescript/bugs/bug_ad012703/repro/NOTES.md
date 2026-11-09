Input: a.ts `const a = 123;\nfunction foo() { }` with a selection (pos 2-9) inside the `const a` statement; asks the language service for the "Move to file" refactor into /bar.ts.
Clean: the selection expands to the whole statement, so edits are produced (a.ts loses `const a`, bar.ts gains it).
Injected: the partial selection of the start node is rejected (getRangeToMove returns undefined), so no edits / an error occurs.
