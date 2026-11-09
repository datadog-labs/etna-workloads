Input: `let x: unknown; export const s = new Set([x]);` with isolatedDeclarations; asks the language service for code fixes on the diagnostic.
Clean: the fix is "Add annotation of type 'Set<unknown>'" (keeps trailing `unknown` type argument).
Injected: the type argument is dropped (e.g. `Set`), since the constraint-skip check was removed.
