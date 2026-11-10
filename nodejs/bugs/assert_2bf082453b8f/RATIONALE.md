# assert: fix TypeError on deepStrictEqual with null Map key or Set member

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 2bf082453b8ffd224b84e631af47e6aab8b4e097 applied to v26.13.0 (clean).

Upstream commit message:

```
assert: fix TypeError on deepStrictEqual with null Map key or Set member

deepStrictEqual() and util.isDeepStrictEqual() threw "Cannot read
properties of null (reading 'constructor')" instead of comparing when
a Map key or Set member was null/undefined (or another primitive) and
lined up against object-only keys/members in the other collection with
an equal count. The primitive/null handling was gated behind an
optimization that is skipped when the counts match, letting such keys
reach objectComparisonStart, which dereferences `.constructor`.

Resolve primitive and null keys/members directly in every case.

Signed-off-by: semx <7532921+semx@users.noreply.github.com>
PR-URL: https://github.com/nodejs/node/pull/64449
Reviewed-By: Jordan Harband <ljharb@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
