input.ts has a comment containing the word "meta" followed by `const x = import.meta;`. The script calls languageService.findReferences on `meta` in `import.meta`.
Clean: returns results normally. Injected: the comment occurrence yields the SourceFile node (not filtered out), so the result differs (or errors).
