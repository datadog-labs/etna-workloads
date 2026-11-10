input.ts has an interface with computed keys `[b.KEY_1]`, `[a.KEY_2]`, `[a.KEY_3]` (const objects `a`, `b`), and a variable `foo: I`. run.mjs asks the language service for completions after `foo.` with includeCompletionsWithInsertText.
Clean: duplicate entries for the same leftmost symbol `a` are skipped, so `key_3` is not listed.
Injected: the dedupe check is missing, so an extra `key_3` completion entry appears.
