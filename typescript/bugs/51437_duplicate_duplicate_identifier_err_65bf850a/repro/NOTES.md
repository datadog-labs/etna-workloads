Input: a class with a method `foo` and a getter `foo` (duplicate identifier), checked via the API `program.getSemanticDiagnostics(sourceFile)`.
Clean: duplicate diagnostics (reported by both binder and checker) are deduplicated, so each error appears once (2 total, one per declaration).
Injected: per-file diagnostics are not sorted/deduplicated, so duplicate "Duplicate identifier" errors appear (4 total).
