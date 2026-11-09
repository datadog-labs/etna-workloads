Input: /a.ts exports `namespace A` with a function; /b.ts imports A and calls undefined `A.fn()`.
The script asks the language service for the "add missing function declaration" code fix in /b.ts.
Clean: the edit targets /a.ts (inside the namespace). Injected: the edit targets /b.ts (the calling file), wrong file.
