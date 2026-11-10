# bootstrap: call _undestroy() inside _destroy for stdout and stderr

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 33f9b7f80bd224a96ca66f8a0021eaa67a5e3685 applied to v26.13.0 (clean).

Upstream commit message:

```
bootstrap: call _undestroy() inside _destroy for stdout and stderr

This change makes `process.stdout` and `process.stderr` to be
automatically undestroyed when ended/destrouyed, therefore making
it always possible to write/console.log to stdout.

Fixes: https://github.com/nodejs/node/issues/39447

PR-URL: https://github.com/nodejs/node/pull/39685
Reviewed-By: Robert Nagy <ronagy@icloud.com>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: Joyee Cheung <joyeec9h3@gmail.com>
```
