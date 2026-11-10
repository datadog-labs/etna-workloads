# http: don't destroy socket after request completes

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 77d8f17ab1617c109f0839088a2125d05a3ebe60 applied to v26.13.0 (clean).

Upstream commit message:

```
http: don't destroy socket after request completes

Aborting a ClientRequest after the request has finished sending
and the response has fully arrived has nothing left to cancel.
destroy() still called socket.destroy(err), but the resulting
'error' is emitted on a later tick. In that window,
responseKeepAlive() has already removed socketErrorListener while
handing the socket back to the agent's free pool, so the error
lands with no listener and crashes the process.

Skip the socket destroy when there is nothing left to cancel. This
matches the existing behavior of keepAlive: false requests, which
already drop any unread buffered response data in this situation.

Fixes: https://github.com/nodejs/node/issues/65938
Signed-off-by: Barath <barathraj048@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65952
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
