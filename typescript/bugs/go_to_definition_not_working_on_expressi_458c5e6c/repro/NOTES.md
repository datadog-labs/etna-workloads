Input: an object literal `{ title: ... } satisfies Record<string,string>`, later used as `STRINGS.title`.
The script asks the language service for go-to-definition on the `title` property name inside the literal.
Clean: returns the `title` definition. Injected: returns an empty list (the empty array from the object-literal path blocks the symbol fallback).
