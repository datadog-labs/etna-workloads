# stream: reject closed only after sink abort settles

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 898cd55bdfcd6def5500cf3f12aecbcbbab8c298 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: reject closed only after sink abort settles

Signed-off-by: Lazizbek Ergashev <lazerg2@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65727
Fixes: https://github.com/nodejs/node/issues/65726
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
```
