input.ts spreads `find('foo') ?? { label: 'Foo' }` (type `Thing | { label: string }`) after an explicit `id: 'foo'` property, under --strict.
`id` exists only in one union constituent, so the spread may not overwrite it, and the clean build reports no error.
The injected build drops the Partial check in checkSpreadPropOverrides and reports a false TS2783 ("'id' is specified more than once").
