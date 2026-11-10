# fs: fix glob early return skipping sibling entries

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 74dcdbb5f1d00cbe47d8ce95906bafc5e5991392 applied to v26.13.0 (clean).

Upstream commit message:

```
fs: fix glob early return skipping sibling entries

The children loop in the glob traversal returned from the whole method
when a child path had already been seen through a different pattern
context, silently dropping the remaining sibling entries. Whether this
triggered depended on directory iteration order, which also made
test-fs-glob.mjs flaky.

Remove the check: the cache.add call at the start of the traversal
already prevents reprocessing.

Fixes: https://github.com/nodejs/node/issues/62897
Co-authored-by: semimikoh <ejffjeosms@gmail.com>
Signed-off-by: webdevelopersrinu <webdeveloper.srinu9@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/64895
Reviewed-By: Aviv Keller <me@aviv.sh>
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
```
