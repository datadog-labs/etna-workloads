Language-service script: a class in a .d.ts has a method whose signature uses authored `import("./generation.js").X` types; a subclass is asked for class-member completions (snippets on).
Clean build: insertText keeps the authored `import("./generation.js").GenerationConfigType`.
Injected build: the import type node has no symbol, so the code reads `firstIdentifier.symbol` as undefined and the result differs and the completion request crashes ("Cannot read properties of undefined").
