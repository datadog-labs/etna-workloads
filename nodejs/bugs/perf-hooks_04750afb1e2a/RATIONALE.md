# Bug
`performance.getEntriesByName(name, type)` ignored the optional `type` argument, so it always returned entries of all types for the name.

# Change (lib/internal/perf/performance.js)
- Signature hunk: `getEntriesByName(name, type = undefined)` -> `getEntriesByName(name)`; matches the fix's signature hunk.
- Body hunk: removed the `if (type !== undefined) type = \`${type}\`` coercion and pass `undefined` to `filterBufferMapByNameAndType(name, undefined)`; matches the fix's body hunk.

# Failing test
parallel/test-performance-timeline: `getEntriesByName('a', 'mark')` returns all four entries (measure, mark, measure, mark) instead of ['mark','mark'], so the deepStrictEqual assertion fails ("not ok").
