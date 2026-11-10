Input: a generic `bar1<P extends "" | "bar" | "baz">(p: { type: P })` called as `bar1({ type: "" })`; run.mjs asks the language service for completions inside the empty string literal.
Clean: lists "", "bar", "baz" (IgnoreNodeInferences contextual type is also consulted).
Injected: the partially-typed string fixes P, so the list is incomplete (only the already-typed literal).
