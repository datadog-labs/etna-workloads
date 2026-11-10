Creates a language service sharing a document registry, loads a program, then calls `cleanupSemanticCache()` and `dispose()`. A second service on the same registry then loads the same file.
Clean: `cleanupSemanticCache` releases the registry refs, so the second service gets a fresh SourceFile (prints `false`).
Injected: `cleanupSemanticCache` only drops the program without releasing, and `dispose` has nothing left to release. The registry entry leaks, so the SourceFile is reused (prints `true`).
