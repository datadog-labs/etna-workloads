# http: fix keylog listener setup on existing agent sockets

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 6c3516f17970248ea19078026426970e85ced511 applied to v26.13.0 (clean).

Upstream commit message:

```
http: fix keylog listener setup on existing agent sockets

`maybeEnableKeylog()` runs as the agent's `'newListener'` handler and
attaches the agent's keylog handler to the sockets the agent already
owns. `agent.sockets` maps a name to an array of sockets, but the loop
treated those arrays as sockets and called `.on()` on them.

Adding a `'keylog'` listener to an agent that already owned a socket
therefore threw `TypeError: sockets[i].on is not a function` out of
`agent.on('keylog', ...)`. Since the throw happened inside the
`'newListener'` handler it propagated before the listener was stored,
so the caller got an exception and no listener. Sockets parked in
`agent.freeSockets` were never visited at all.

Walk both maps the way `Agent.prototype.destroy()` does.

Signed-off-by: Shani Singh <teamdeveloperworld@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65066
Reviewed-By: Tim Perry <pimterry@gmail.com>
```
