# worker: fix broadcast channel SharedArrayBuffer passing

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 67643e1c2ecc380a0d92550eb7ce2d283c8c6184 applied to v26.13.0 (clean).

Upstream commit message:

```
worker: fix broadcast channel SharedArrayBuffer passing

Make sure that `SharedArrayBuffer`s can be deserialized on multiple
receiving ends. As a drive-by, also fix the condition of the
internal assertion that should occur if there are transferables
passed to multiple destinations.

PR-URL: https://github.com/nodejs/node/pull/36501
Reviewed-By: Michaël Zasso <targos@protonmail.com>
Reviewed-By: Gus Caplan <me@gus.host>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
