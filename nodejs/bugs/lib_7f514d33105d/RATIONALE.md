# lib: fix shared buffer growability validation

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 7f514d33105da2db61e8eecc05d8a7f3b857171d applied to v26.13.0 (clean).

Upstream commit message:

```
lib: fix shared buffer growability validation

Use the intrinsic growable getter instead of buffer.growable so
shadowed properties cannot bypass validation or reject fixed buffers.

Signed-off-by: Filip Skokan <panva.ip@gmail.com>
Assisted-by: GitHub Copilot
PR-URL: https://github.com/nodejs/node/pull/65845
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
```
