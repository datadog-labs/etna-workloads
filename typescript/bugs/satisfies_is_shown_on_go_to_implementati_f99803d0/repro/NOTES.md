Language-service go-to-implementation on interface `I`, which is used in `{ foo: '' } satisfies I`.
Clean build returns the object literal expression as an implementation; the injected build
(satisfies no longer handled like `as` assertions) returns nothing ("none").
