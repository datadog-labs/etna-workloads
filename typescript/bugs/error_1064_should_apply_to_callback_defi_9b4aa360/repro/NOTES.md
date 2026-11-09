A JS file (checkJs, target es5) has an `async function` annotated with `/** @type {X} */`, where X is a `@callback` whose `@returns {never}`.
Clean build reports TS1065 (async return type must be global Promise<T>) at the `@type` reference; the injected build doesn't, because it ignores the @type-tag's callback return type when checking the signature.
