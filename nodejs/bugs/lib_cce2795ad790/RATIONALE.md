# lib: fix AbortSignal.any() abort propagation

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit cce2795ad79082f491868a854a36fd7f245caf26 applied to v26.13.0 (clean).

Upstream commit message:

```
lib: fix AbortSignal.any() abort propagation

Follow composite signal sources at construction so abort state is
propagated even without listeners, before sources can be collected.
Keep the existing weak-reference finalization and timeout cleanup.

Cover source collection before each state accessor, including nested
composites, and cleanup of unreachable listener-less dependents.

Fixes: https://github.com/nodejs/node/issues/65995
Refs: https://github.com/nodejs/node/issues/62363
Assisted-by: Codex
Signed-off-by: inoway46 <inoueyuya416@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/66014
Reviewed-By: Robert Nagy <ronagy@icloud.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Xuguang Mei <meixuguang@gmail.com>
Reviewed-By: Ulises Gascón <ulisesgascongonzalez@gmail.com>
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
```
