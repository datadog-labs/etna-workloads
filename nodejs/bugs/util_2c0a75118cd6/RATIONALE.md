# Re-introduced bug: util.inspect on iterable types with a special prototype

## Bug
`util.inspect` should use the special "iterable type" formatting path (Array, Set, Map,
TypedArray) only when needed, i.e. for a null prototype, or when the value has
`Symbol.iterator`. Before the fix, the fallback was taken for any prototype without
`Symbol.iterator`. An array whose prototype was replaced (e.g. with `Number.prototype`)
was still visualized as an array (`Number(3) [ 1, 2, 3 ]`) instead of being shown as
a plain object (`Number { '0': 1, '1': 2, '2': 3 }`).

## Change
The code the fix touched (`noPrototypeIterator`) no longer exists. Its job is now done
inside `formatRaw` in `lib/internal/util/inspect.js`. The one hunk corresponds to the fix's
hunk that added `if (constructor === null)` around the fallback: it is the guard that
limits the fallback. I removed the guard by changing
`if (SymbolIterator in value || constructor === null)` to `if (true)`, so the
Array/Set/Map/TypedArray detection runs for every prototype. This restores the old
behaviour.

Side effect: `SymbolIterator` is now an unused import. That only matters for lint.

## Failing test
`parallel/test-util-inspect` fails on every run (two runs, both "not ok"):

```
AssertionError [ERR_ASSERTION]: Expected values to be strictly equal:
+ 'Number(3) [ 1, 2, 3 ]'
- "Number { '0': 1, '1': 2, '2': 3 }"
    at test/parallel/test-util-inspect.js:2545
```
