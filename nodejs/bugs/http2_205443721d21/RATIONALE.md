# http2: fix onread assert when destroying session from stream handler

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 205443721d214ceb683dbd57e41d4e3df04ffd70 applied to v26.13.0 (clean).

Upstream commit message:

```
http2: fix onread assert when destroying session from stream handler

When session.destroy() runs from a 'stream' handler, MakeCallback drains
nextTick while nghttp2 is still inside mem_recv. Close is deferred for
that window (see #64166), so later HEADERS in the same buffer created
C++ streams without a JS wrapper or onread, and DATA delivery aborted
with Assertion failed: onread->IsFunction().

- Reject new streams while the session is closing
- Destroy the C++ handle if on_headers runs after JS destroy
- Drop DATA when onread is not installed (defensive)

Fixes: https://github.com/nodejs/node/issues/64850
Signed-off-by: Sankalp Thakur <sankalphimself@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65116
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Tim Perry <pimterry@gmail.com>
```
