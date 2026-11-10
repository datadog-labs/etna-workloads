# test_runner: print coverage and diagnostic info with dot reporter

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 79c39c217d9cae91c21047c96017eb2cf89f3306 applied to v26.13.0 (clean).

Upstream commit message:

```
test_runner: print coverage and diagnostic info with dot reporter

When using the dot reporter with coverage enabled, coverage threshold
failures and coverage reports were not printed, only an exit code was
returned. This made it impossible to know why the test run failed.

This change adds handling for test:diagnostic and test:coverage events
to the dot reporter, matching the behavior of the spec reporter.

Fixes: https://github.com/nodejs/node/issues/60884
Signed-off-by: mag123c <diehreo@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/61423
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
Reviewed-By: Xuguang Mei <meixuguang@gmail.com>
Reviewed-By: Aviv Keller <me@aviv.sh>
```
