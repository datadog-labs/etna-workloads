Language service on a .ts file with `{@link nonexistent}` and `{@link x.y}` JSDoc links; calls getDefinitionAtPosition at the link names and prints semantic diagnostics.
Clean: go-to-definition on unresolved JSDoc links produces no errors (semantic diagnostics empty).
Injected: resolving the link name reports errors (e.g. "Cannot find name"), which show up as extra semantic diagnostics.
