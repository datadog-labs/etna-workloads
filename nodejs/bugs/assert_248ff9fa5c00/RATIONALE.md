# assert,util: fix TypeError on Maps with null keys

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 248ff9fa5c00e66dc127d806522cdadf15e1100f applied to v26.13.0 (clean).

Upstream commit message:

```
assert,util: fix TypeError on Maps with null keys

`assert.deepStrictEqual`, `assert.notDeepStrictEqual`, and
`util.isDeepStrictEqual` threw a `TypeError` instead of returning a
result when one Map had a `null` key with an object value, the other
had an object key with a deeply-equal value but no `null` key, and
both maps were the same size.

In that case `mapObjectEquiv` skipped its primitive and `null` key
handling, which was gated on `array.length !== a.size`, and passed
the `null` key (which is `typeof 'object'`) to the object comparator.
That comparator reads `key.constructor` without a null guard, so it
threw. Handle primitive and `null` keys unconditionally, resolving
them directly against the other map.

Fixes: https://github.com/nodejs/node/issues/64433
Signed-off-by: Paul Bouchon <mail@bitpshr.net>
PR-URL: https://github.com/nodejs/node/pull/64441
Reviewed-By: Jordan Harband <ljharb@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Aviv Keller <me@aviv.sh>
```
