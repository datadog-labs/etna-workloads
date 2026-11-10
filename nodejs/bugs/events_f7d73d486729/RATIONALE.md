# events: fix adding abort listener in `events.once`

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit f7d73d486729f41512ee18ba542c3eee11c7bcad applied to v26.13.0 (fuzzy).

Upstream commit message:

```
events: fix adding abort listener in `events.once`

Event listeners passed to un/subscribe the abort event are mismatched.
This removes the wrapper function in `eventTargetAgnosticAddListener()`
and directly passes the given listener to the `EventTarget`.

IMO, removing the wrapper seems harmless, and the `AbortSignal` is
seemingly the only `EventTarget` passed to this function for now.

Fixes: https://github.com/nodejs/node/issues/43337
Refs: https://github.com/nodejs/node/pull/33659
Refs: https://github.com/nodejs/node/pull/34997

Signed-off-by: Daeyeon Jeong daeyeon.dev@gmail.com

PR-URL: https://github.com/nodejs/node/pull/43373
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
```
