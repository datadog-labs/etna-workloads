types.d.ts declares a function and `export as namespace foo`; foo.ts declares a global function `foo` merging with it.
Clean: compiles without crashing. Injected: checker reads `node.parent.kind` on the SourceFile declaration (parent undefined) and crashes with a TypeError.
