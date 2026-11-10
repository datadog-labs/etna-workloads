Input: bar.ts imports `{ Foo }` from foo.ts, which does `export { Foo }` with no such local binding; the script runs language-service findReferences on `Foo` in bar.ts.
Clean: returns reference results normally. Injected: skipExportSpecifierSymbol returns undefined, so findReferences throws a TypeError (script prints "threw true").
