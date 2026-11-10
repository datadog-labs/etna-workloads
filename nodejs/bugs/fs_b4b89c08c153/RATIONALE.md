# fs: handle recursive watch setup races

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b4b89c08c15381853ad60d244f27ce69ecf10c7a applied to v26.13.0 (clean).

Upstream commit message:

```
fs: handle recursive watch setup races

Arm directory watchers before reading entries to close the setup
window. Discard stale watcher state when paths disappear so recreated
paths can be watched again.

On AIX, treat ENODEV as missing only when stat confirms the path is
gone. Preserve root throwIfNoEntry behavior and other watch errors.

Fixes: https://github.com/nodejs/node/issues/65697

Signed-off-by: Filip Skokan <panva.ip@gmail.com>
Assisted-by: Codex
PR-URL: https://github.com/nodejs/node/pull/65699
Fixes: https://github.com/nodejs/node/issues/65697
Reviewed-By: Shelley Vohr <shelley.vohr@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
