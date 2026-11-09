Input: an exported function whose parameter is a destructuring pattern with renames (`{ a: b, c: d }`), emitted with `--declaration`.
Clean: the .d.ts keeps the rename, `{ a: b, c: d }: {...}`.
Injected: the rename is dropped and the .d.ts reads `{ a: a, c: c }`-style (propertyName used as the name, e.g. `{ a, c }`), which changes the binding names.
