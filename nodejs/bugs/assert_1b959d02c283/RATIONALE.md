# assert,util: fix stale nested cycle memo entries

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 1b959d02c283103cc48d1b5a88f0fcf0ed6bece0 applied to v26.13.0 (clean).

Upstream commit message:

```
assert,util: fix stale nested cycle memo entries

Temporary nested cycle-tracking entries could remain in the memory set
after a successful comparison. If a later sibling comparison reused one
of those objects, deepStrictEqual could incorrectly fail for equivalent
structures.
This cleans up the temporary nested entries after the nested
comparison returns.

Fixes: https://github.com/nodejs/node/issues/62422
PR-URL: https://github.com/nodejs/node/pull/62509
Fixes: https://github.com/nodejs/node/issues/62422
Reviewed-By: Jordan Harband <ljharb@gmail.com>
```
