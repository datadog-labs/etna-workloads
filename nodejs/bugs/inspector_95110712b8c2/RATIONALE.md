# inspector: fix abort when two Environments own the inspector

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 95110712b8c27408c58420e460e9a78db0811b86 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
inspector: fix abort when two Environments own the inspector

Two Environments with default flags alive at the same time (for
example the embedding.md example run on two threads, or two
`CommonEnvironmentSetup`s) aborted the process: `Agent::Start()` bound
one file-level static `uv_async_t` to the current Environment's loop
for every Environment with `kOwnsInspector`, which `kDefaultFlags`
implies, and CHECKed that nobody else had. Environments created one
after another did not abort, but each ran `StartDebugSignalHandler()`
again, which re-initialized the semaphore the watchdog waits on and
spawned another detached watchdog thread, leaking one thread per
Environment.

Give every Agent that asks for the debug signal handler its own async
handle, keep those Agents in a mutex-protected list that the watchdog
(or the Windows remote thread) walks, and set the watchdog up once per
process while still unblocking SIGUSR1 on each Environment's thread.
The handle is heap-allocated, closed by the cleanup hook or `~Agent()`,
whichever runs first, and freed by its close callback. A SIGUSR1 now
reaches every Environment that asked for the handler, and no longer
starts the inspector of one that passed `kNoStartDebugSignalHandler`.

Refs: https://github.com/nodejs/node/pull/25777
Signed-off-by: Shelley Vohr <shelley.vohr@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65877
Refs: https://github.com/nodejs/node/pull/44121
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
