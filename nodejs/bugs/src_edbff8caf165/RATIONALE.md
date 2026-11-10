# src: fix --process-timeout message when exit waits

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit edbff8caf165f2bdcf7bac200d0209dfc214a8ae applied to v26.13.0 (clean).

Upstream commit message:

```
src: fix --process-timeout message when exit waits

process.exit(), uncaught exceptions and unhandled rejections exit
through Environment::Exit(), which never calls OnEnvironmentStopping().
If a Worker blocked in a synchronous native call held up that exit past
the deadline, the watchdog blamed the main thread.

Check Environment::is_stopping() and report that the process did not
finish exiting instead.

Signed-off-by: Trivikram Kamat <16024985+trivikr@users.noreply.github.com>
Assisted-by: claude:opus-5.5
PR-URL: https://github.com/nodejs/node/pull/66361
Fixes: https://github.com/nodejs/node/issues/66360
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
```
