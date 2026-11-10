# test_runner: always make spec the default reporter

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit eb7e18fe9446666d5b81e59167817becc8554a77 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
test_runner: always make spec the default reporter

This is a breaking change. Prior to this commit, the test_runner
defaulted to the spec reporter if using a TTY, and the TAP
reporter otherwise. This commit makes spec the default reporter
unconditionally. TAP output is still available via the
--test-reporter=tap CLI flag.

Fixes: https://github.com/nodejs/node/issues/54540
PR-URL: https://github.com/nodejs/node/pull/54548
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Michaël Zasso <targos@protonmail.com>
Reviewed-By: Moshe Atlow <moshe@atlow.co.il>
Reviewed-By: Jake Yuesong Li <jake.yuesong@gmail.com>
```
