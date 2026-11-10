# http2: fix write deadlock exposed by larger window sizes

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b4a7cd3efb658c57fb3cb1517916f887bb20d4d3 applied to v26.13.0 (clean).

Upstream commit message:

```
http2: fix write deadlock exposed by larger window sizes

This removes a guard (no reads while write pending) that creates
this deadlock, which was added as a security mechanism. This guard is
redundant given then other existing mechanisms, and a test is added to
demonstrate that.

Signed-off-by: Tim Perry <pimterry@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65440
Backport-PR-URL: https://github.com/nodejs/node/pull/65953
Signed-off-by: Filip Skokan <panva.ip@gmail.com>
Assisted-by: Codex
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Richard Lau <richard.lau@ibm.com>
Reviewed-By: Tim Perry <pimterry@gmail.com>
```
