# lib: fix benchmark record acknowledgement race

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 062ece77fc0a694287f7cd9e3734f9851ddafb51 applied to v26.13.0 (clean).

Upstream commit message:

```
lib: fix benchmark record acknowledgement race

The child can receive an acknowledgement and send its next record before
the parent's send callback runs. Clear recordPending before sending the
acknowledgement to avoid rejecting that record as an invalid sequence.

Add a regression test that delays send callbacks until the child sends
its next record or closes.

Signed-off-by: Filip Skokan <panva.ip@gmail.com>
Assisted-by: Codex
PR-URL: https://github.com/nodejs/node/pull/66430
Reviewed-By: James M Snell <jasnell@gmail.com>
```
