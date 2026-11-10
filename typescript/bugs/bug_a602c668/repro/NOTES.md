Uses the language service "Move to file" refactor to move a statement from /a.ts (single-quoted imports) into an existing, import-less /bar.ts.
Clean: the generated imports in /bar.ts keep the source file's quote style ('./a', './other').
Injected: they use default double quotes ("./a", "./other"), because the old file's quote preference is ignored.
