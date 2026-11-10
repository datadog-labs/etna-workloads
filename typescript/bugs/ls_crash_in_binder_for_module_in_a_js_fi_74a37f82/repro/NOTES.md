Input: a.js and b.js each contain a `namespace` declaration with `this.x = ...` inside (JS files, --allowJs --checkJs, emitting with --outDir).
Clean: reports TS8006 ("'namespace' declarations can only be used in TypeScript files") for both files.
Injected: the binder hits `Debug.failBadSyntaxKind` for a ModuleDeclaration this-container, so tsc crashes with "Debug Failure. Unexpected node."
Note: with --noEmit the crash does not occur, so the repro emits.
