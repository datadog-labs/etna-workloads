# events: fix weak listener retention overwrite

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit ed1b629901437f373f9bcdac91d19beb04b30a92 applied to v26.13.0 (clean).

Upstream commit message:

```
events: fix weak listener retention overwrite

The weakListeners() retention map in EventTarget stored a single
listener per retainer key. Multiple addEventListener() calls sharing
the same retainer (e.g. two listeners on one target using the same
AbortSignal) silently evicted each other's strong reference, allowing
the evicted listener to be garbage collected before its signal
aborted, so only the most recently registered listener was ever
actually removed on abort.

Changed the retention map to store a Set of listeners per retainer
key instead of a single listener, and added matching cleanup in
remove() so entries are released once their retainer's set is empty.

This also fixes the same class of bug in events.aborted() and the
streams kWeakHandler usage, since both go through the same
EventTarget.prototype.addEventListener() code path.

Fixes: https://github.com/nodejs/node/issues/63954
Signed-off-by: aryan7905 <aryansrivastava354@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/64024
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Aviv Keller <me@aviv.sh>
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
```
