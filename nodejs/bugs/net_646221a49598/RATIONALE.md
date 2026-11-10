# net: handle undefined parent in _unrefTimer and _destroy

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 646221a4959819525979a9ce0dcfa9e617ef7963 applied to v26.13.0 (clean).

Upstream commit message:

```
net: handle undefined parent in _unrefTimer and _destroy

The fix and approach are from #64491 by Shivay-98; this reopens it to
get it landed, since the original stalled awaiting requested changes.

`Socket.prototype._unrefTimer` and `Socket.prototype._destroy` both walk
the `_parent` chain with a strict `!== null` check. During connection
teardown a socket's `_parent` can be left `undefined` (for example a TLS
socket layered over another stream), so the loop steps onto `undefined`
and reads a property off it, throwing a TypeError:

    Cannot read properties of undefined (reading 'Symbol(timeout)')

from an uncaught I/O callback and crashing the process.

Using a nullish (`!= null`) check terminates the walk on both `null` and
`undefined`.

[petter@hightouch.io: apply the same fix to the identical loop in
`_destroy`, which the original regression test already exercised via
`destroy()`; add direct unit coverage for both paths.]

Fixes: https://github.com/nodejs/node/issues/64490
Refs: https://github.com/nodejs/node/pull/64491

Signed-off-by: Petter Häggholm <petter@hightouch.io>
PR-URL: https://github.com/nodejs/node/pull/64644
Fixes: https://github.com/nodejs/node/issues/64490
Refs: https://github.com/nodejs/node/pull/64491
Reviewed-By: Tim Perry <pimterry@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Ethan Arrowood <ethan@arrowood.dev>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
