# test_runner: align mock timeout api

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit a8c773a0c7a48fe17c55f51577a18913cc6214f0 applied to v26.13.0 (clean).

Upstream commit message:

```
test_runner: align mock timeout api

Expose Timeout.close() and Timeout[Symbol.dispose]() from MockTimers.

This keeps fake setTimeout() handles aligned with the public
Timeout API so disposal-based patterns do not throw.

Add targeted coverage for Timeout.close() and
Timeout[Symbol.dispose]().

Signed-off-by: sangwook <rewq5991@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/62820
Fixes: https://github.com/nodejs/node/issues/62815
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
Reviewed-By: Moshe Atlow <moshe@atlow.co.il>
Reviewed-By: Jacob Smith <jacob@frende.me>
```
