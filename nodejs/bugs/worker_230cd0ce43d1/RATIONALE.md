# worker: fix postMessage overload resolution

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 230cd0ce43d12a3c6f7fd22b5ec4cbb7a2d0ea34 applied to v26.13.0 (clean).

Upstream commit message:

```
worker: fix postMessage overload resolution

Web IDL overload resolution treats functions as objects, accepts a null
iterator as missing, and retrieves the iterator method only once. Reuse
that method during sequence conversion in both postMessage entry points.

Signed-off-by: Filip Skokan <panva.ip@gmail.com>
Assisted-by: Codex
PR-URL: https://github.com/nodejs/node/pull/66354
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Aviv Keller <me@aviv.sh>
```
