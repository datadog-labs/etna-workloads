Input: a TS file with a JSDoc comment containing two `@typedef` tags (FooString, FooNum) followed by a statement.
The script asks the language service for suggestion diagnostics (80009) and the "Convert typedef to TypeScript type" code fixes.
Clean: 2 diagnostics/fixes (one per typedef). Injected: only 1, since only the first typedef in the comment is found.
