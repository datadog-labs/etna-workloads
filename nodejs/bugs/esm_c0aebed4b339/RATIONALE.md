# esm: fix inconsistency with `importAssertion` in `resolve` hook

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c0aebed4b3395bd65d54b18d1fd00f071002ac20 applied to v26.13.0 (clean).

Upstream commit message:

```
esm: fix inconsistency with `importAssertion` in `resolve` hook

As the documentation states, the `context.importAssertion` should be
still supported and emit a warning. This is true for the `load` hook,
but not correct for context of the `resolve` hook.

This commit fixes the inconsistency.

PR-URL: https://github.com/nodejs/node/pull/55365
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
