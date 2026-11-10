# Rationale
Bug: in the REPL, a static `import x from 'y'` produced Node's generic "Cannot use import statement outside a module" SyntaxError, which is ambiguous and doesn't say static import is unsupported in the REPL.

Hunk (lib/repl.js, error handler for SyntaxError in REPLServer): removes the block that detects "Cannot use import statement outside a module" in e.message and rewrites e.message/e.stack to "Cannot use import statement inside the Node.js REPL, alternatively use dynamic import...". This corresponds to the fix's single lib/repl.js hunk (adapted to today's code: SideEffectFreeRegExpPrototypeSymbolReplace, toDynamicImport). The `StringPrototypeIncludes` import is kept since it is still used elsewhere.

Failing test: parallel/test-repl (the tcp test sending `import comeOn from 'fhqwhgads'` expects /^SyntaxError: .* dynamic import/ but receives the original message).
