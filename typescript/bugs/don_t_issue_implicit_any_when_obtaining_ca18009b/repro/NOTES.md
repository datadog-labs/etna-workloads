index.js is a checkJs file with a destructured parameter `{ a: { json = [] } = {} } = {}` whose JSDoc type gives `json` the type string[].
Clean: no diagnostics. Injected: bogus error TS7031 "Binding element 'json' implicitly has an 'any[]' type" and exit code 2.
