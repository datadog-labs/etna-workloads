# process: ignore asyncId 0 in exception handler

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 51783320a4d72eacc8956e371f443b901806533f applied to v26.13.0 (fuzzy).

Upstream commit message:

```
process: ignore asyncId 0 in exception handler

Today, the global uncaught exception handler is the only
place where asyncId 0 is not ignored and we still proceed
to call emitAfter. This would've already failed one of
our correctness tests in async_hooks if not for some other
code meant to handle a different edge case.

Fixes: https://github.com/nodejs/node/issues/22982

PR-URL: https://github.com/nodejs/node/pull/41424
Reviewed-By: Gerhard Stöbich <deb2001-github@yahoo.de>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
