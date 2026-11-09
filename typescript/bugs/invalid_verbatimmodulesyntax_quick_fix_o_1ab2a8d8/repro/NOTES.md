Three in-memory files with verbatimModuleSyntax: a.ts exports function `f`; b.ts imports it, declares `type f` and re-exports `f` (value+type); c.ts imports `{ I, f }` from b and re-exports both.
The language service is asked for code fixes on the c.ts diagnostics.
Clean: only "Use 'type I'" is offered, because `f` is also a value. Injected: the "convert to type-only import" fix is also offered for `f` (the value check was lost), which would be invalid.
