# watch: strip underscore aliases of watch flags

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit ab057989af947bbce2d469556958524e3d404e51 applied to v26.13.0 (clean).

Upstream commit message:

```
watch: strip underscore aliases of watch flags

The C++ option parser treats `_` and `-` as the same character in
option names, so `--watch_path` is the same as `--watch-path`.

Watch mode compared spellings literally when it removed its own flags
from `process.execArgv` and `NODE_OPTIONS` before spawning the child.
The underscore spellings got through, so each child went back into
watch mode and spawned another child, and the application never ran.

Normalize option names before comparing them. Forward the original
arguments to the child unchanged.

Signed-off-by: Trivikram Kamat <16024985+trivikr@users.noreply.github.com>
Assisted-by: claude:opus-5.5
PR-URL: https://github.com/nodejs/node/pull/66365
Fixes: https://github.com/nodejs/node/issues/66364
Reviewed-By: Moshe Atlow <moshe@atlow.co.il>
```
