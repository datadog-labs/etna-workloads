# src: fix Stop() terminating the next Environment on the isolate

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit afc3e559d21251eb979c7fdb396b59e059325636 applied to v26.13.0 (clean).

Upstream commit message:

```
src: fix Stop() terminating the next Environment on the isolate

After `Stop(env)`, freeing the Environment and creating another one on
the same isolate failed whenever no JavaScript ran in between: the new
Environment's first script was terminated before it started. That is
the normal case when `Stop()` is called from the process exit handler
for an uncaught exception, or by an embedder while the loop is idle.
`Stop()` calls `isolate->TerminateExecution()` unless
`kDoNotTerminateIsolate` is set, and V8 only clears that request the
next time JavaScript runs, so it outlived the Environment it was meant
for.

Cancel a pending termination when the Environment it was meant for is
freed. `Worker::Run()` already did this by hand before freeing its
Environment, with a TODO asking why V8 hit a DCHECK without it; this is
why, and that call now happens in `FreeEnvironment()`.

Refs: https://github.com/nodejs/node/pull/33347
Signed-off-by: Shelley Vohr <shelley.vohr@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65819
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
```
