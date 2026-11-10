A checkJs file declares a `@typedef` with an optional `@property {number} [a]`, under `exactOptionalPropertyTypes`, then assigns `{ a: undefined }` to it.
Clean build: reports TS2375, because the optional property doesn't accept an explicit `undefined`.
Injected build: reports no error, because JSDoc property tags are no longer treated as properties when computing optionality.
