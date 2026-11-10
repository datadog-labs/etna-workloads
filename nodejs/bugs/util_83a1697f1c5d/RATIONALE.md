# util: fix inspect indentation of detached DataView

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 83a1697f1c5d125aa87ef3fd23a81e082b0f121b applied to v26.13.0 (clean).

Upstream commit message:

```
util: fix inspect indentation of detached DataView

formatExtraProperties() raised ctx.indentationLvl before reading the
property. The getters of a detached DataView throw, so the level was
never lowered again, and the DataView and everything inspected after it
in the same call ended up indented too far. Read the value first.

Signed-off-by: Miodrag Obradovic <mck097@gmail.com>
Assisted-by: a closed-source coding agent
PR-URL: https://github.com/nodejs/node/pull/66421
Refs: https://github.com/nodejs/node/pull/60131
Reviewed-By: Jordan Harband <ljharb@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
