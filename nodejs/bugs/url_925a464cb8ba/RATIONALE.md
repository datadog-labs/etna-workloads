# Re-introduced bug (fix 925a464cb8ba, "url: remove #context from URLSearchParams")

**Bug:** Before the fix, every URLSearchParams mutation eagerly wrote `this.#context.search = this.toString()`
into the owning URL (a full re-parse/update per mutation, slow). The URL accessors (`href`, `toString()`,
`toJSON()`, `search`) did not sync lazily, so they did not begin with `#ensureSearchParamsUpdated()`.
The accessors therefore threw "Cannot read private member #context" on a bad receiver instead of
"Receiver must be an instance of class".

## Hunks (all in lib/internal/url.js)
1. `URLSearchParams.#markUpdated` (was append/set/etc. hunks in the fix): `setURLSearchParamsModified(this.#context)`
   -> `this.#context.search = this.toString()`. Reverses the fix's replacement of eager search writes with lazy flagging.
2. `URLSearchParams` removeAll/delete-style filter hunk (~line 590): same replacement, same reason.
3. Removed `this.#ensureSearchParamsUpdated()` from `URL#toString`, `href`, `search` getters and `toJSON`, and from
   `getURLHref`. Corresponds to the fix's added lazy-sync calls in these accessors; since updates are eager again
   the flag is never set, so they are redundant and the old behaviour (no sync call first) returns.
The lazy helper functions themselves are left in place (now unused).

## Failing test
`parallel/test-whatwg-url-invalidthis` fails (stable across 2 runs):
`message: 'Cannot read private member #context from an object whose class did not declare it'`
vs expected `/Receiver must be an instance of class/`.
`test-whatwg-url-custom-searchparams` still passes (eager sync is functionally equivalent).
