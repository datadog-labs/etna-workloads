# http: ensure agent data guard works without I/O

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 0683ee5f7d512332c9701a3e06cdeec2c34bcdbf applied to v26.13.0 (clean).

Upstream commit message:

```
http: ensure agent data guard works without I/O

Before a kept-alive socket is given to a request, now ask the OS
whether anything is waiting to be read on it. If there is, the
Agent destroys the socket and uses another one or opens a new
connection. The check doesn't consume any bytes.

Signed-off-by: James M Snell <jasnell@gmail.com>
Assisted-by: Opencode
PR-URL: https://github.com/nodejs-private/node-private/pull/983
Fixes: https://hackerone.com/reports/4038361
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
CVE-ID: CVE-2026-105481
```
