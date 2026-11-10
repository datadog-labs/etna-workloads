# dns: validate resolve inputs for null bytes

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 6b78ea171de305446126cb94ceb6a45b6297466c applied to v26.13.0 (clean).

Upstream commit message:

```
dns: validate resolve inputs for null bytes

Signed-off-by: James M Snell <jasnell@gmail.com>
Assisted-by: Opencode
PR-URL: https://github.com/nodejs-private/node-private/pull/984
Fixes: https://hackerone.com/reports/4038342
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
CVE-ID: CVE-2026-105482
```
