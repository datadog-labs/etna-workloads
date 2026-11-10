# zlib: fix use-after-free when reset() is called during write

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 53bcd114b10021c4a883b08df4d3c2ff6946b430 applied to v26.13.0 (clean).

Upstream commit message:

```
zlib: fix use-after-free when reset() is called during write

The Reset() method did not check the write_in_progress_ flag before
resetting the compression stream. This allowed reset() to free the
compression library's internal state while a worker thread was still
using it during an async write, causing a use-after-free.

Add a write_in_progress_ guard to Reset() that throws an error if a
write is in progress, matching the existing pattern used by Close()
and Write().

PR-URL: TODO
Refs: https://hackerone.com/reports/3609132
PR-URL: https://github.com/nodejs/node/pull/62325
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
