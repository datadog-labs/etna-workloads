Input: a checkJs file with braceless JSDoc `@type () => string` / `(a: number) => void` tags.
Clean: the tags parse as function types, so the checker reports the expected diagnostics.
Injected: the scanner in JSDoc mode no longer returns `(`/`)` tokens, so the type is parsed differently and the diagnostics differ.
