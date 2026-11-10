# dgram: check udp buffer size to avoid fd leak

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 61e4ad535281fca6418e1417175253560253deca applied to v26.13.0 (fuzzy).

Upstream commit message:

```
dgram: check udp buffer size to avoid fd leak

PR-URL: https://github.com/nodejs/node/pull/56084
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
