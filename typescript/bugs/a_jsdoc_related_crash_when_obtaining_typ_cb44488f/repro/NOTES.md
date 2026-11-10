Input: a class method whose JSDoc `@returns {Promise<{upStatement, downStatement}>}` has a type literal type argument; run.cjs requests completions (language service) right after `upStatement`.
Clean: completions return normally (`["readonly"]`).
Injected: the type-literal type resolution is missing the `!node.symbol` guard, so it crashes (prints `CRASH ...`).
