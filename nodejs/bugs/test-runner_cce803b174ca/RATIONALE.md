# test_runner: use run options with isolation="none"

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit cce803b174ca6f19d0ce9274f0b5449b9ba14d87 applied to v26.13.0 (clean).

Upstream commit message:

```
test_runner: use run options with isolation="none"

When using run() programatically with isolation="none",
testNamePatterns, testSkipPattersn, and only were ignored.
This combination of options only worked when set via CLI flags,
because parseCommandLine() is still used to seed globalOptions.

Fixes: https://github.com/nodejs/node/issues/57399
Signed-off-by: Sylvester Keil <sylvester@keil.or.at>
PR-URL: https://github.com/nodejs/node/pull/62269
Reviewed-By: Ethan Arrowood <ethan@arrowood.dev>
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
Reviewed-By: Pietro Marchini <pietro.marchini94@gmail.com>
```
