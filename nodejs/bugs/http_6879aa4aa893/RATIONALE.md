# http: propagate highWaterMark to ClientRequest OutgoingMessage

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 6879aa4aa893ec62be369d74e00de022b509f99f applied to v26.13.0 (fuzzy).

Upstream commit message:

```
http: propagate highWaterMark to ClientRequest OutgoingMessage

`http.request({ highWaterMark })` passes the value to the TCP socket
via createConnection() but does not set it on the OutgoingMessage
internal kHighWaterMark.  OutgoingMessage._writeRaw() has two mutually
exclusive write paths:

  Path A (socket connected): conn.write() — uses socket HWM ✓
  Path B (no socket yet):    outputSize < this[kHighWaterMark] — uses
                             OutgoingMessage own default (64 KB) ✗

Because the OutgoingMessage constructor already accepts
options.highWaterMark, the fix is to set kHighWaterMark from the
user options after they are parsed in the ClientRequest constructor.

This resolves two symptoms:

  1. write() returning the wrong boolean for pre-socket writes (the
     user highWaterMark was silently ignored on all Node versions).

  2. A deadlock on Node >= 24.16.0 where the incorrect false return
     sets kNeedDrain, but drain never fires because the socket was
     never backpressured (introduced by the stricter drain gate in
     #62936).

Signed-off-by: Naman Trivedi <trivenay@amazon.com>
Fixes: https://github.com/nodejs/node/issues/64645
Refs: https://github.com/nodejs/node/pull/62936
PR-URL: https://github.com/nodejs/node/pull/64653
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
Reviewed-By: Tim Perry <pimterry@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
