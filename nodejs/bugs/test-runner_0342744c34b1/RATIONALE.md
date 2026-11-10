# test_runner: add timestamp to JUnit reporter testsuites

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 0342744c34b1b3cf4eb8676d938b562c20a61f75 applied to v26.13.0 (clean).

Upstream commit message:

```
test_runner: add timestamp to JUnit reporter testsuites

Emit the standard JUnit timestamp (ISO 8601) on <testsuite> elements,
which the reporter was omitting. The suite start time is reconstructed
as end-minus-duration, because the runner reports a suite's test:start
lazily (when its first subtest reports), which would otherwise record a
time close to the suite's end.

Fixes: https://github.com/nodejs/node/issues/64028
Signed-off-by: sangwook <rewq5991@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/64029
Reviewed-By: Moshe Atlow <moshe@atlow.co.il>
Reviewed-By: Jacob Smith <jacob@frende.me>
```
